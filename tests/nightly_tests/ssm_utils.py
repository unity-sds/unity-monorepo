import sys
import boto3

# region has to be specified either via [default] or environment
client = boto3.client('ssm')

# return the value of the indicated SSM parameter
def get_parameter(parameterName, wDecryption = True):
    parameter = client.get_parameter(Name=parameterName, WithDecryption=wDecryption)
    return parameter ['Parameter']['Value']

def main():
    args = sys.argv[1:]
    if len(args) <= 0:
        return
    if len(args) == 1:
        print(get_parameter(args[0]))
    else:
        print(get_parameter(args[0], wDecryption=bool(args[1])))

if __name__ == "__main__":
    main()
