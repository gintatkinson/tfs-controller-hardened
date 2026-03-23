import os, sys
sys.path.append('/var/teraflow')
from common.proto.context_pb2 import Empty, ContextId, TopologyId, Context, Topology, Device, DeviceId, DeviceOperationalStatusEnum
from context.client.ContextClient import ContextClient

def main():
    try:
        client = ContextClient()
        client.connect()
        
        # Context
        context_id = ContextId()
        context_id.context_uuid.uuid = 'admin'
        client.SetContext(Context(context_id=context_id, name='admin'))
        
        # Topology
        topology_id = TopologyId()
        topology_id.context_id.CopyFrom(context_id)
        topology_id.topology_uuid.uuid = 'admin'
        client.SetTopology(Topology(topology_id=topology_id, name='admin'))

        # Device
        device = Device()
        device.device_id.device_uuid.uuid = 'R1-EMU'
        device.name = 'R1-EMU'
        device.device_type = 'emulator'
        device.device_operational_status = DeviceOperationalStatusEnum.DEVICEOPERATIONALSTATUS_ENABLED
        client.SetDevice(device)
        
        # Add device to topology
        topology = client.GetTopology(topology_id)
        topology.device_ids.add().CopyFrom(device.device_id)
        client.SetTopology(topology)

        print('Success! Data injected.')
    except Exception as e:
        print(f"Error: {e}")
    finally:
        client.close()

if __name__ == '__main__':
    main()
