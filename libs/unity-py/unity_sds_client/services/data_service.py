from mdps_ds_lib.ds_client.auth_token.token_abstract import TokenAbstract
from mdps_ds_lib.ds_client.ds_client_admin import DsClientAdmin
from mdps_ds_lib.ds_client.ds_client_user import DsClientUser
from pystac import Item, Collection
from unity_sds_client.resources.collection import Collection as UnityCollection
from unity_sds_client.resources.data_file import DataFile
from unity_sds_client.resources.dataset import Dataset
from unity_sds_client.unity_exception import UnityException
from unity_sds_client.unity_session import UnitySession
import warnings

class UnitySessionToken(TokenAbstract):

    def __init__(self, unity_session: UnitySession) -> None:
        super().__init__()
        self.__unity_session = unity_session

    def get_token(self):
        return self.__unity_session.get_auth().get_token()


class DataService(DsClientUser, DsClientAdmin):
    """
    The DataService class is a wrapper to the data endpoint(s) within Unity. This wrapper interfaces with the DAPA endpoints.

    The DataService class allows for the querying of data collections and data files within those collections.
    """

    def __init__(self, session: UnitySession, endpoint: str = None, ds_stage: str = 'am-uds-dapa'):
        endpoint = endpoint[:-1] if endpoint.endswith('/') else endpoint
        super().__init__(UnitySessionToken(session), endpoint, ds_stage)
        self.__session = session
        self.urn, self.org, self.project = 'org', 'nasa', 'unity'

        # self.project, self.tenant, self.tenant_venue = self.__session.get_project(), self.__session.get_venue(), self.__session.get_venue_id()

    # @property
    # def project(self):
    #     return self.__session.get_project()
    #
    # @property
    # def tenant(self):
    #     return self.__session.get_venue()
    #
    # @property
    # def tenant_venue(self):
    #     return self.__session.get_venue_id()

    def __update_setting(self, complete_collection_id: str):
        split_id = complete_collection_id.split(':')
        if len(split_id) != 6:
            raise UnityException(f'invalid MDPS format: <urn>:<org>:<project>:<tenant>:<venue>:<collection-id>')

        pure_collection_id = split_id[-1]
        self.urn, self.org, self.project, self.tenant, self.tenant_venue = split_id[0], split_id[1], split_id[2], split_id[3], split_id[4]
        if '___' in pure_collection_id:
            self.collection, self.collection_venue = pure_collection_id.split('___')
        else:
            self.collection = pure_collection_id
        return self

    def get_collections(self, limit=10, output_stac=False):
        warnings.warn("get_collections is deprecated and will be removed in future versions. Use query_collections instead.", category=DeprecationWarning, stacklevel=2)
        """Returns a list of collections

        Returns
        -------
        list
            List of returned collections

        """
        try:
            result = self.query_collections(limit)
            if output_stac:
                return result
            result = [UnityCollection(k['id']) for k in result['features']]
        except Exception as e:
            raise UnityException(e)
        return result

    def get_collection_data(self, collection:UnityCollection, limit=10, filter: str = None, output_stac=False):
        warnings.warn("get_collection_data is deprecated and will be removed in future versions. Use query_granules instead.", category=DeprecationWarning, stacklevel=2)
        datasets = []
        try:
            self.__update_setting(collection.collection_id)
            result = self.query_granules(limit=limit, filter=filter)
            if output_stac:
                return result
            # result = [Item.from_dict(k) for k in result]
            for dataset in result['features']:
                ds = Dataset(dataset['id'], collection.collection_id, dataset['properties']['start_datetime'],
                             dataset['properties']['end_datetime'], dataset['properties']['created'],
                             properties=dataset['properties'])

                for asset_key in dataset['assets']:
                    location = dataset['assets'][asset_key]['href']
                    file_type = dataset['assets'][asset_key].get('type', "")
                    title = dataset['assets'][asset_key].get('title', "")
                    description = dataset['assets'][asset_key].get('description', "")
                    roles = dataset['assets'][asset_key]["roles"] if "roles" in dataset['assets'][asset_key] else [
                        "metadata"] if asset_key in ['metadata__cmr', 'metadata__data'] else [asset_key]
                    ds.add_data_file(DataFile(file_type, location, roles=roles, title=title, description=description))

                datasets.append(ds)


        except Exception as e:
            raise UnityException(e)
        return datasets

    def create_collection(self, collection: UnityCollection, dry_run=False):
        warnings.warn("create_collection is deprecated and will be removed in future versions. Use create_new_collection instead.", category=DeprecationWarning, stacklevel=2)
        try:
            self.__update_setting(collection.collection_id)
            if dry_run:
                return
            self.create_new_collection()
        except Exception as e:
            raise UnityException(e)
        return

    def define_custom_metadata(self, metadata: dict):
        self.add_tenant_database_index(metadata)
        return

    def delete_collection_item(self, collection: UnityCollection, granule_id: str = None):
        warnings.warn("delete_collection_item is deprecated and will be removed in future versions. Use delete_single_granule instead.", category=DeprecationWarning, stacklevel=2)
        """
            Delete a granule from given a collection
            Parameters
            -------
            collection: Collection
                The collection object associated to the granule to delete
            granule_id: String
                The granule id to delete

    	"""
        if (granule_id == "") or (granule_id is None):
            raise UnityException("Error deleting collection data: Please provide granule ID")
        try:
            self.__update_setting(collection.collection_id)
            self.granule = granule_id.replace(collection.collection_id, '')[1:] if granule_id.startswith(collection.collection_id) else granule_id
            self.delete_single_granule()
        except Exception as e:
            raise UnityException("Error deleting collection: " + e)
        return

    def delete_dataset(self, dataset: Dataset):
        warnings.warn("delete_dataset is deprecated and will be removed in future versions. Use delete_single_granule instead.", category=DeprecationWarning, stacklevel=2)
        """
            Delete an item from a Collection given Dataset object
            Parameters
            ----------
            dataset: Dataset
        """
        self.delete_collection_item(Collection(dataset.collection_id), dataset.id)
        return
