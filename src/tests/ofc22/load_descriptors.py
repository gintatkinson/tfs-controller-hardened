import os, sys, json
sys.path.append('/var/teraflow')
from common.tools.descriptor.Loader import DescriptorLoader
from context.client.ContextClient import ContextClient
from device.client.DeviceClient import DeviceClient

def main():
    try:
        # Note: In the pod, this path is /var/teraflow/tests/ofc22/descriptors_emulated.json
        # In the VM, it's /home/ubuntu/xgai-cogctrl/src/tests/ofc22/descriptors_emulated.json
        descriptor_file = '/var/teraflow/tests/ofc22/descriptors_emulated.json'
        if not os.path.exists(descriptor_file):
            descriptor_file = '/home/ubuntu/xgai-cogctrl/src/tests/ofc22/descriptors_emulated.json'
            
        with open(descriptor_file, 'r') as f:
            descriptors = json.load(f)
        
        loader = DescriptorLoader(descriptors, context_client=ContextClient(), device_client=DeviceClient())
        loader.process()
        print('Success! Descriptors loaded.')
    except Exception as e:
        print(f"Error: {e}")

if __name__ == '__main__':
    main()
