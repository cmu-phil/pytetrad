import jpype
import jpype.imports

# this needs to happen before import pytetrad (otherwise lib cant be found)
try:
    jpype.startJVM(classpath=[f"resources/tetrad-gui-7.2.2-launch.jar"])
except OSError:
    print("JVM already started")

import pytetrad.simulate as util

D, G = util.simulateDiscrete(num_meas=100, samp_size=1000)

# Save data to a file
D.to_csv('../mydata.csv', index=False)

# To save out causal learn graph:
with open('../mygraph.txt', 'w') as f:
    f.write(str(G))
