import unity_sds_apgs_client
from unity_sds_apgs_client import AdsAcbMcpCloneGet200Response
from unity_sds_client.unity_exception import UnityException
from unity_sds_client.unity_session import UnitySession

from .application_catalog.dockstore import DockstoreAppCatalog

class ApplicationService(object):
    """
    """

    def __init__(
        self, session: UnitySession, endpoint: str = None, debug: bool = False
    ):
        """
        Initialize the ApplicationService class.

        Parameters
        ----------
        session : UnitySession
            The Unity Session that will be used to facilitate making calls to the Application endpoints.
        endpoint : str
            An endpoint URL to override the endpoint specified in the package's config.

        Returns
        -------
        ProcessService
            The Process Service object.
        """
        self._session = session
        self._debug = debug
        if endpoint is None:
            # end point is the combination of the processes API and the project/venue
            # self._session.get_unity_href()
            self.endpoint = self._session.get_unity_href()

    def build_application_package(self, repo_url) -> AdsAcbMcpCloneGet200Response:
        """
        Submit github repository for application-package build. This interacts with a Unity shared service so
        project/venue are not required for this method.

        :param repo_url: the publicly accessible repository that you want to convert into an applicaiton package.
        Examples include https://github.com/unity-sds/unity-example-application
        :return  AdsAcbMcpCloneGet200Response:
        """
        token = self._session.get_auth().get_token()
        url = self.endpoint

        # The access_token as of 8/2/2024 is not being repsected so we have a work around being used below.
        configuration = unity_sds_apgs_client.Configuration(
            host=url, access_token=token, debug=self._debug
        )

        with unity_sds_apgs_client.ApiClient(configuration) as api_client:
            # This is a workaround (suggested in https://github.com/OpenAPITools/openapi-generator/issues/8865) that
            # fixes the outstanding bug
            api_client.default_headers["Authorization"] = "Bearer " + token
            api_instance = unity_sds_apgs_client.api.DefaultApi(api_client)
            try:
                ads_clone_repo_response = api_instance.ads_acb_mcp_clone_get(repo_url)
                return ads_clone_repo_response
            except Exception as e:
                print(traceback.format_exc())
                print(
                    "Exception when calling DefaultApi->ads_acb_mcp_clone_get: %s\n" % e
                )
                raise UnityException(
                    "Exception when calling DefaultApi->ads_acb_mcp_clone_get: %s\n" % e
                )

    def dockstore_api(self, api_url, token):
        app_catalog = DockstoreAppCatalog(api_url, token)
        return app_catalog