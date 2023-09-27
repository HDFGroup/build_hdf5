# Return the number of CTest failures from the last CDash submission
# from a given host name.
import sys
import json
import sys

v = sys.argv

if len(v) != 3:
    print('cdash.py hostname buildname')
    sys.exit(1)
    
json_file = 'out.json'
try:
    with open(json_file) as data_file:
        try:
            data = json.load(data_file)
        except ValueError:
            print('ERROR:Invalid json file')
            sys.exit(1)
except IOError:
    print('ERROR:cannot open '+json_file)
    sys.exit(1)

n = len(data['buildgroups'][0]['builds'])
b = data['buildgroups'][0]['builds']

# Print the number of CTest failures of hostname argument.
found = False
for i in reversed(range(0, n)):
    if (b[i]['site'] == v[1] and b[i]['buildname'] == v[2] and not found):
        found = True
        print(b[i]['test']['fail'])

if not found:
    sys.exit(1)
