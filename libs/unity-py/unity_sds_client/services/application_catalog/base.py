from abc import ABC, abstractmethod
from attrs import define, field

class ApplicationCatalogAccessError(Exception):
    "An error occuring when attempting to access an application catalog"
    pass

@define
class ApplicationPackage(object):
    """
    Describes an application package either stored within an application catalog or that
    can be registered with an application catalog.
    """

    # Required arguments
    artifact_name: str
    namespace: str

    # Optional
    source_repository: str = None

    # Dockstore hard-codes the primary descriptor path for the hosted workflow
    workflow_path: str = None

    id: str = None  # Not yet commited to catalog
    is_published: bool = False
    description: str = ""

    # The type of application package
    workflow_type: str = field(default="")

class ApplicationCatalog(ABC):
    """
    Abstract interface for interacting with an application catalog in an implementation agnostic way
    """

    def __init__(self):
        """ """
        pass

    @abstractmethod
    def application(self, app_id):
        "Retrieve an ApplicationPackage from the catalog based on application id"
        pass

    @abstractmethod
    def application_list(self):
        "Return a list of ApplicationPackage objects representing the applications the catalog knows about"
        pass

    @abstractmethod
    def register(self, application, publish=True):
        "Register an ApplicationPackage object into the catalog, optionally publish it"
        pass

    @abstractmethod
    def publish(self, application):
        "Publish an ApplicationPackage object into the catalog"
        pass

    @abstractmethod
    def unpublish(self, application):
        "Unpublish an ApplicationPackage object into the catalog"
        pass