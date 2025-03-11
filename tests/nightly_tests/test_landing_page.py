import boto3
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
import selenium.common.exceptions
import sys

def get_ssm_parameter(parameter_name):
    """Get parameter value from SSM, supporting cross-account access"""
    ssm_client = boto3.client('ssm', region_name='us-west-2')
    
    # First get the shared services account ID
    try:
        account_response = ssm_client.get_parameter(
            Name='/unity/shared-services/aws/account'
        )
        account_id = account_response['Parameter']['Value']
        
        # Construct the full ARN for cross-account parameter access
        parameter_arn = f"arn:aws:ssm:us-west-2:{account_id}:parameter{parameter_name}"
        
        # Get the actual parameter using the ARN
        response = ssm_client.get_parameter(
            Name=parameter_arn,
            WithDecryption=True
        )
        return response['Parameter']['Value']
    except Exception as e:
        print(f"Error accessing SSM parameter: {str(e)}")
        raise

def setup_driver():
    """Setup Chrome WebDriver with appropriate options"""
    chrome_options = Options()
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--headless')  # Run in headless mode
    chrome_options.add_argument('--disable-dev-shm-usage')
    
    # Connect to Selenium standalone container
    driver = webdriver.Remote(
        command_executor='http://localhost:4444/wd/hub',
        options=chrome_options
    )
    return driver

def test_landing_page(landing_page_url, max_time_seconds=300, interval=10):
    start_time = time.time()
    last_error = None
    attempt = 1

    while (time.time() - start_time) < max_time_seconds:
        driver = None
        try:
            print(f"\nAttempt {attempt} - Time elapsed: {int(time.time() - start_time)} seconds")
            
            # Get credentials from SSM
            username = get_ssm_parameter('/unity/shared-services/cognito/monitoring-username')
            password = get_ssm_parameter('/unity/shared-services/cognito/monitoring-password')
            
            # Setup WebDriver
            driver = setup_driver()
            
            print(f"Navigating to {landing_page_url}")
            driver.get(landing_page_url)
            
            # Wait for username field and login form
            username_field = WebDriverWait(driver, 20).until(
                EC.presence_of_element_located((By.ID, "signInFormUsername"))
            )
            password_field = driver.find_element(By.ID, "signInFormPassword")
            
            # Input credentials
            username_field.send_keys(username)
            password_field.send_keys(password)
            
            # Find and click the sign-in button
            sign_in_button = driver.find_element(By.NAME, "signInSubmitButton")
            sign_in_button.click()
            
            # Wait for redirect and check for welcome message
            welcome_text = WebDriverWait(driver, 20).until(
                EC.presence_of_element_located((By.XPATH, "//*[contains(text(), 'Welcome to the Unity Management Console')]"))
            )
            
            if welcome_text:
                print("\nSUCCESS: Found 'Welcome to the Unity Management Console' on the page!")
                return True
                
        except Exception as e:
            last_error = str(e)
            print(f"Attempt {attempt} failed. Retrying in {interval} seconds...")
            time.sleep(interval)
            attempt += 1
        finally:
            if driver:
                driver.quit()

    # If we get here, we've exceeded the maximum time
    print(f"\nERROR: Failed to verify Management Console after {max_time_seconds} seconds.")
    if last_error:
        print(f"Last error encountered: {last_error}")
    print(f"\nYou can manually verify the Management Console by visiting:")
    print(f"{landing_page_url}")
    return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 test_landing_page.py <landing_page_url> [max_time_seconds]")
        sys.exit(1)
        
    landing_page_url = sys.argv[1]
    max_time = int(sys.argv[2]) if len(sys.argv) > 2 else 300
    success = test_landing_page(landing_page_url, max_time_seconds=max_time)
    if not success:
        exit(1)  # Exit with error code if test failed 