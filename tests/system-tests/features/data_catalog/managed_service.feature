Feature: MDPS_2_REQ-29
The MDPS shall provide a shared data catalog for cataloging and search of MDPS data products based on product metadata.

Scenario: Connection to shared data catalog via DAPA
   Given a venue has been deployed
   When a user requests access to the catalog via DAPA collection endpoint
   Then a successful connection response is received

Scenario: Deploy the U-DS service via Unity Marketplace
   Given a venue has been deployed
   And the User has set authentication
   When the User specifies a version for the U-DS service via Unity Marketplace
   And provided deployment details/variables and confirmed installation
   Then U-DS service with given details will be installed on a given venue. 
