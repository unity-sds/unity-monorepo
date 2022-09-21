
from unity_py.unity_session import UnitySession
import requests
from unity_py.resources.collection import Collection
from unity_py.resources.dataset import Dataset
from unity_py.resources.data_file import DataFile

class DataManager:
    """
    The DataManager class is a wrapper to the data endpoint(s) within Unity. This wrapper interfaces with the DAPA endpoints.

    The DataManager class allows for the querying of data collections and data files within those collections.
    """

    def __init__(
        self,
        session: UnitySession,
        endpoint: str = None,
    ):
        """Initialize the DataManager class.

        Parameters
        ----------
        session : UnitySession
            Description of parameter `session`.
        endpoint : str
            The endpoint used to access teh data manager API. This is usually
            shared across Unity Environments, but can be Overidden. Defaults to
            "None", and will be read form the configuration if not set.

        Returns
        -------
        DataManager
            the Data Manager object.

        """
        self._session = session
        if endpoint is None:
            self.endpoint = self._session.get_service_endpoint("data", "dapa_endpoint")

    def get_collections(self):
        """Returns a list of collections

        Returns
        -------
        list
            List of returned collections

        """
        url = self.endpoint + "am-uds-dapa/collections"
        token = self._session.get_auth().get_token()
        response = requests.get(url, headers={"Authorization": "Bearer " + token})
        # build collection objects here
        collections = []
        for data_set in response.json()['features']:
            collections.append(Collection(data_set['id']))

        return collections

    def get_collection_data(self, collection: type= Collection):
        datasets = []
        url = self.endpoint + f'am-uds-dapa/collections/{collection.collection_id}/items'
        token = self._session.get_auth().get_token()
        response = requests.get(url, headers={"Authorization": "Bearer " + token})
        results = response.json()['features']

        for dataset in results:
            ds = Dataset(dataset['id'], collection.collection_id, dataset['properties']['start_datetime'], dataset['properties']['end_datetime'], dataset['properties']['created'])
            ds.add_data_file(DataFile("data" ,dataset['assets']['data']['href']))
            ds.add_data_file(DataFile("metadata" ,dataset['assets']['metadata__data']['href']))
            datasets.append(ds)


        return datasets
