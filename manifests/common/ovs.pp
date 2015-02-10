class openstack::common::ovs {
  $data_network        = $::openstack::config::network_data
  $data_address        = ip_for_network($data_network)
  $enable_tunneling    = $::openstack::config::neutron_tunneling # true
  $tunnel_types        = $::openstack::config::neutron_tunnel_types #['gre']
  $tenant_network_type = $::openstack::config::neutron_tenant_network_type # ['gre']
  $type_drivers        = $::openstack::config::neutron_type_drivers # ['gre']
  $mechanism_drivers   = $::openstack::config::neutron_mechanism_drivers # ['openvswitch']
  $tunnel_id_ranges    = $::openstack::config::neutron_tunnel_id_ranges # ['1:1000']
  $network_vlan_ranges  = hiera(openstack::neutron::network_vlan_ranges) # ['physnet1:1000:2999'],
  $provider_bridge      = hiera(openstack::neutron::provider_network_device)
  $provider_bridge_2    = hiera(openstack::neutron::provider_network_device_2)
  $provider_bridge_flat = hiera(openstack::neutron::provider_network_device_flat)
  $bridge_mappings      = hiera(openstack::neutron::bridge_mappings)
  $bridge_uplinks       = hiera(openstack::neutron::bridge_uplinks)

  class { '::neutron::agents::ml2::ovs':
    enable_tunneling => $enable_tunneling,
    local_ip         => $data_address,
    enabled          => true,
    tunnel_types     => $tunnel_types,
    bridge_mappings  => $bridge_mappings,
    bridge_uplinks   => $bridge_uplinks,
  }

  class  { '::neutron::plugins::ml2':
    type_drivers         => $type_drivers,
    tenant_network_types => $tenant_network_type,
    mechanism_drivers    => $mechanism_drivers,
    tunnel_id_ranges     => $tunnel_id_ranges
    network_vlan_ranges   => $network_vlan_ranges, # added for vlan network support
  }
}