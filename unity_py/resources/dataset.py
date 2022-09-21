from unity_py.resources.data_file import DataFile

class Dataset(object):
    """The Dataset object contains metadata about a collection within the Unity system, and also is a container for the data_files within a dataset.

    A Dataset can be made up of one or more files. A data file is the most common data_file wihtin a dataset. Other examples include metadata, browse imagery, checksums, etc.
    """

    def __str__(self):
        return f'unity_py.resources.Dataset(data_id={self.id})'

    def __repr__(self):
        return self.__str__()

    def __init__(self, name, collection_id, start_time, end_time, creation_time ):
        """Dataset object construction)

        Parameters
        ----------
        name : type
            Name of the dataset in the Unity system
        collection_id : str
            Collection identifer that this dataset belongs to
        start_time : type
            start time of the data coverage within the dataset
        end_time : type
            end time of the data coverage within the dataset
        creation_time : type
            The time a daset was created

        Returns
        -------
        Dataset
            The dataset object

        """
        self.id = name
        self.collection_id = collection_id
        self.datafiles = []
        self.data_begin_time = start_time
        self.data_end_time = end_time
        self.data_create_time = creation_time

    def add_data_file(self, datafile: type=DataFile):
        """adds a data file to a dataset

        Parameters
        ----------
        datafile : DataFile
            a uity_py.resource.datafile object containg the location of data products.

        """
        self.datafiles.append(datafile)
