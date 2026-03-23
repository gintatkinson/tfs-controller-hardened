import sys
sys.path.append('/var/teraflow')
from common.proto.context_pb2 import Empty
from context.client.ContextClient import ContextClient
def main():
    try:
        client = ContextClient()
        client.connect()
        contexts = client.ListContexts(Empty())
        devices = client.ListDevices(Empty())
        print(f"Contexts count: {len(contexts.contexts)}")
        for c in contexts.contexts:
            print(f" - ID: {c.context_id.context_uuid.uuid}, Name: {c.name}")
        print(f"Devices count: {len(devices.devices)}")
        for d in devices.devices:
            print(f" - ID: {d.device_id.device_uuid.uuid}, Name: {d.name}")
        client.close()
    except Exception as e:
        print(f"Error: {e}")
if __name__ == '__main__':
    main()
