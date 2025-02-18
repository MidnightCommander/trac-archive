#-------------------------------------------------------------------------------
#                       DGS-3612 Gigabit Ethernet Switch
#                                Configuration
#
#                           Firmware: Build 2.50.B25
#           Copyright(C) 2008 D-Link Corporation. All rights reserved.
#-------------------------------------------------------------------------------

# DOUBLE_VLAN
disable double_vlan

# BASIC
config serial_port auto_logout 10_minutes
disable telnet
disable web
enable clipaging

# STORM
config traffic trap none
config traffic control 1-12 broadcast disable multicast disable unicast disable action drop threshold 131072 countdown 0 time_interval 5

# LOOP_DETECT
config loopdetect recover_timer 60 interval 30 mode port-based
config loopdetect trap both

# GM
config sim candidate
disable sim
config sim dp_interval 30
config sim hold_time 100

# GM_H

# SYSLOG
enable syslog
config system_severity log information
config system_severity trap information
create syslog host 1 severity all facility local7 udp_port 514 ipaddress 10.0.41.12 state enable
config log_save_timing time_interval 10

# QOS
config scheduling_mechanism weight_fair
config scheduling 0 max_packet 1
config scheduling 1 max_packet 2
config scheduling 2 max_packet 4
config scheduling 3 max_packet 5
config scheduling 4 max_packet 7
config scheduling 5 max_packet 11
config scheduling 6 max_packet 15
config 802.1p user_priority 0 2
config 802.1p user_priority 1 0
config 802.1p user_priority 2 1
config 802.1p user_priority 3 3
config 802.1p user_priority 4 4
config 802.1p user_priority 5 5
config 802.1p user_priority 6 6
config 802.1p user_priority 7 6
enable hol_prevention
config 802.1p default_priority 1-12 0
config bandwidth_control 1-12 rx_rate no_limit tx_rate no_limit

# MIRROR
disable mirror

# TRAF-SEGMENTATION
config traffic_segmentation 1-12 forward_list all

# SSL
enable ssl
enable ssl ciphersuite RSA_with_RC4_128_MD5
enable ssl ciphersuite RSA_with_3DES_EDE_CBC_SHA
enable ssl ciphersuite DHE_DSS_with_3DES_EDE_CBC_SHA
enable ssl ciphersuite RSA_EXPORT_with_RC4_40_MD5
config ssl cachetimeout 28800

# PORT
disable jumbo_frame
config ports 1-8 speed auto capability_advertised 10_half 10_full 100_half 100_full 1000_full flow_control disable learning enable state enable
config ports 9-12 medium_type copper speed auto capability_advertised 10_half 10_full 100_half 100_full 1000_full flow_control disable learning enable state enable
config ports 9-12 medium_type fiber speed auto capability_advertised 100_full 1000_full flow_control disable learning enable state enable

# PORT_LOCK
config port_security ports 1-12 admin_state disable max_learning_addr 1 lock_address_mode DeleteOnReset

# SNMPv3
delete snmp community public
delete snmp community private
delete snmp user initial
delete snmp group initial
delete snmp group ReadGroup
delete snmp group WriteGroup
delete snmp view restricted all
delete snmp view CommunityView all
config snmp engineID 800000ab03001cf0b60700
create snmp view restricted 1.3.6.1.2.1.1 view_type included
create snmp view restricted 1.3.6.1.2.1.11 view_type included
create snmp view restricted 1.3.6.1.6.3.10.2.1 view_type included
create snmp view restricted 1.3.6.1.6.3.11.2.1 view_type included
create snmp view restricted 1.3.6.1.6.3.15.1.1 view_type included
create snmp view CommunityView 1 view_type included
create snmp view CommunityView 1.3.6.1.6.3 view_type excluded
create snmp view CommunityView 1.3.6.1.6.3.1 view_type included
create snmp group initial v3 noauth_nopriv read_view restricted notify_view restricted
create snmp group ReadGroup v1 read_view CommunityView notify_view CommunityView
create snmp group ReadGroup v2c read_view CommunityView notify_view CommunityView
create snmp group sample v1 read_view CommunityView notify_view CommunityView
create snmp group sample v2c read_view CommunityView notify_view CommunityView
create snmp group sample v1 read_view CommunityView write_view CommunityView notify_view CommunityView
create snmp group sample v2c read_view CommunityView write_view CommunityView notify_view CommunityView
create snmp group WriteGroup v1 read_view CommunityView write_view CommunityView notify_view CommunityView
create snmp group WriteGroup v2c read_view CommunityView write_view CommunityView notify_view CommunityView
create snmp community sample view CommunityView read_only
create snmp community sample view CommunityView read_write
create snmp user initial initial

# MANAGEMENT
enable snmp traps
enable snmp authenticate_traps
disable snmp
enable snmp linkchange_traps
config snmp system_name SW41
config snmp system_location Floor 4, server room
config snmp system_contact Leonid <it@stolyarenko.com>
disable rmon
config snmp linkchange_traps ports 1-12 enable

# VLAN
enable pvid auto_assign
config vlan default delete 1-12
config vlan default advertisement disable
create vlan GST01 tag 101
config vlan GST01 add tagged 1 advertisement disable
create vlan GST11 tag 111
config vlan GST11 add tagged 2 advertisement disable
create vlan GST21 tag 121
config vlan GST21 add tagged 5 advertisement disable
create vlan GST22 tag 122
config vlan GST22 add tagged 5 advertisement disable
create vlan GST31 tag 131
config vlan GST31 add tagged 5 advertisement disable
create vlan GST32 tag 132
config vlan GST32 add tagged 6 advertisement disable
create vlan GST42 tag 142
config vlan GST42 add tagged 8 advertisement disable
create vlan MED01 tag 201
config vlan MED01 add tagged 1 advertisement disable
create vlan MED11 tag 211
config vlan MED11 add tagged 2 advertisement disable
create vlan MED12 tag 212
config vlan MED12 add tagged 3 advertisement disable
create vlan MED23 tag 223
config vlan MED23 add tagged 4 advertisement disable
create vlan MOT12 tag 312
config vlan MOT12 add tagged 3 advertisement disable
create vlan IMD12 tag 412
config vlan IMD12 add tagged 3 advertisement disable
create vlan TCH01 tag 501
config vlan TCH01 add tagged 1 advertisement disable
create vlan SEC01 tag 601
config vlan SEC01 add tagged 1 advertisement disable
create vlan FIN12 tag 712
config vlan FIN12 add tagged 3 advertisement disable
create vlan JSZ32 tag 832
config vlan JSZ32 add tagged 6 advertisement disable
create vlan JSZ33 tag 833
config vlan JSZ33 add tagged 7 advertisement disable
create vlan CNF01 tag 901
config vlan CNF01 add tagged 1 advertisement disable
create vlan VIP01 tag 2001
config vlan VIP01 add tagged 1 advertisement disable
create vlan VIP11 tag 2011
config vlan VIP11 add tagged 2 advertisement disable
create vlan VIP23 tag 2023
config vlan VIP23 add tagged 4 advertisement disable
create vlan VIP33 tag 2033
config vlan VIP33 add tagged 7 advertisement disable
create vlan VIP42 tag 2042
config vlan VIP42 add tagged 8 advertisement disable
create vlan SNR01 tag 3001
config vlan SNR01 add tagged 1 advertisement disable
create vlan SNR11 tag 3011
config vlan SNR11 add tagged 2 advertisement disable
create vlan SNR41 tag 3041
config vlan SNR41 add untagged 11-12 advertisement disable
create vlan PCCTV tag 3997
config vlan PCCTV add tagged 9 advertisement disable
create vlan INTERNET tag 3999
config vlan INTERNET add untagged 10 advertisement disable
create vlan CONTROL tag 4000
config vlan CONTROL add tagged 1-9 advertisement disable
disable qinq
disable gvrp
config gvrp 1-9 state disable ingress_checking disable acceptable_frame tagged_only pvid 4000
config gvrp 10 state disable ingress_checking disable acceptable_frame admit_all pvid 3999
config gvrp 11-12 state disable ingress_checking disable acceptable_frame admit_all pvid 3041

# PROTOCOL_VLAN

# QINQ
config qinq ports 1-12 missdrop disable tpid 0x8100

# RSPAN
disable rspan

# 8021X
disable 802.1x
config 802.1x auth_protocol local
config 802.1x capability ports 1-12 none
config 802.1x auth_parameter ports 1-12 direction both port_control auto quiet_period 60 tx_period 30 supp_timeout 30 server_timeout 30 max_req 2 reauth_period 3600 enable_reauth disable

# guestvlan

# TR

# ACL
create access_profile profile_id 1 ip udp src_port_mask 0xFFFF
config access_profile profile_id 1 add access_id auto_assign ip udp src_port 67 port 1-9,11-12 deny
config access_profile profile_id 1 add access_id auto_assign ip udp src_port 68 port 10 deny
create access_profile profile_id 2 ip tcp src_port_mask 0xFFFF
config access_profile profile_id 2 add access_id auto_assign ip tcp src_port 20 port 10 permit priority 1 replace_priority replace_dscp 14 rx_rate no_limit
config access_profile profile_id 2 add access_id auto_assign ip tcp src_port 21 port 10 permit priority 1 replace_priority replace_dscp 14 rx_rate no_limit
config access_profile profile_id 2 add access_id auto_assign ip tcp src_port 25 port 10 permit priority 1 replace_priority replace_dscp 14 rx_rate no_limit
config access_profile profile_id 2 add access_id auto_assign ip tcp src_port 110 port 10 permit priority 1 replace_priority replace_dscp 14 rx_rate no_limit
config access_profile profile_id 2 add access_id auto_assign ip tcp src_port 143 port 10 permit priority 1 replace_priority replace_dscp 14 rx_rate no_limit
config access_profile profile_id 2 add access_id auto_assign ip tcp src_port 220 port 10 permit priority 1 replace_priority replace_dscp 14 rx_rate no_limit
config access_profile profile_id 2 add access_id auto_assign ip tcp src_port 465 port 10 permit priority 1 replace_priority replace_dscp 14 rx_rate no_limit
config access_profile profile_id 2 add access_id auto_assign ip tcp src_port 993 port 10 permit priority 1 replace_priority replace_dscp 14 rx_rate no_limit
config access_profile profile_id 2 add access_id auto_assign ip tcp src_port 995 port 10 permit priority 1 replace_priority replace_dscp 14 rx_rate no_limit
create access_profile profile_id 3 ip vlan
config access_profile profile_id 3 add access_id auto_assign ip vlan INTERNET port 10 permit rx_rate no_limit
config access_profile profile_id 3 add access_id auto_assign ip vlan SNR41 port 11-12 permit rx_rate no_limit
config access_profile profile_id 3 add access_id auto_assign ip vlan SNR11 port 2 permit rx_rate no_limit
config access_profile profile_id 3 add access_id auto_assign ip vlan SNR01 port 1 permit rx_rate no_limit
config access_profile profile_id 3 add access_id auto_assign ip vlan CONTROL port 1-9 permit rx_rate no_limit
create access_profile profile_id 4 ip destination_ip_mask 255.255.255.255
config access_profile profile_id 4 add access_id auto_assign ip destination_ip 172.16.0.1 port 1-9,11-12 permit rx_rate no_limit
config access_profile profile_id 4 add access_id auto_assign ip destination_ip 255.255.255.255 port 1-12 deny
create access_profile profile_id 5 ip vlan destination_ip_mask 255.255.192.0
config access_profile profile_id 5 add access_id auto_assign ip vlan MED01 destination_ip 10.0.0.0 port 1 permit rx_rate no_limit
config access_profile profile_id 5 add access_id auto_assign ip vlan SEC01 destination_ip 10.0.0.0 port 1 permit rx_rate no_limit
config access_profile profile_id 5 add access_id auto_assign ip vlan TCH01 destination_ip 10.0.0.0 port 1 permit rx_rate no_limit
config access_profile profile_id 5 add access_id auto_assign ip vlan MED11 destination_ip 10.0.0.0 port 2 permit rx_rate no_limit
config access_profile profile_id 5 add access_id auto_assign ip vlan MED12 destination_ip 10.0.0.0 port 3 permit rx_rate no_limit
config access_profile profile_id 5 add access_id auto_assign ip vlan IMD12 destination_ip 10.0.0.0 port 3 permit rx_rate no_limit
config access_profile profile_id 5 add access_id auto_assign ip vlan MOT12 destination_ip 10.0.0.0 port 3 permit rx_rate no_limit
config access_profile profile_id 5 add access_id auto_assign ip vlan FIN12 destination_ip 10.0.0.0 port 3 permit rx_rate no_limit
config access_profile profile_id 5 add access_id auto_assign ip vlan MED23 destination_ip 10.0.0.0 port 4 permit rx_rate no_limit
config access_profile profile_id 5 add access_id auto_assign ip vlan JSZ32 destination_ip 10.0.0.0 port 6 permit rx_rate no_limit
config access_profile profile_id 5 add access_id auto_assign ip vlan JSZ33 destination_ip 10.0.0.0 port 7 permit rx_rate no_limit
config access_profile profile_id 5 add access_id auto_assign ip vlan SEC01 destination_ip 172.17.0.0 port 1 permit rx_rate no_limit
config access_profile profile_id 5 add access_id auto_assign ip vlan JSZ32 destination_ip 172.17.0.0 port 6 permit rx_rate no_limit
config access_profile profile_id 5 add access_id auto_assign ip vlan JSZ33 destination_ip 172.17.0.0 port 7 permit rx_rate no_limit
create access_profile profile_id 6 ip vlan destination_ip_mask 255.255.255.255
config access_profile profile_id 6 add access_id auto_assign ip vlan PCCTV destination_ip 10.8.32.25 port 9 permit rx_rate no_limit
config access_profile profile_id 6 add access_id auto_assign ip vlan PCCTV destination_ip 10.8.33.25 port 9 permit rx_rate no_limit
config access_profile profile_id 6 add access_id auto_assign ip vlan PCCTV destination_ip 10.6.1.19 port 9 permit rx_rate no_limit
config access_profile profile_id 6 add access_id auto_assign ip vlan CNF01 destination_ip 10.0.11.22 port 1 permit rx_rate no_limit
create access_profile profile_id 7 ip vlan destination_ip_mask 255.255.255.192
config access_profile profile_id 7 add access_id auto_assign ip vlan PCCTV destination_ip 172.31.0.192 port 9 permit rx_rate no_limit
create access_profile profile_id 8 ip destination_ip_mask 255.255.0.0
config access_profile profile_id 8 add access_id auto_assign ip destination_ip 172.16.0.0 port 1-12 deny
config access_profile profile_id 8 add access_id auto_assign ip destination_ip 172.17.0.0 port 1-12 deny
config access_profile profile_id 8 add access_id auto_assign ip destination_ip 172.18.0.0 port 1-12 deny
config access_profile profile_id 8 add access_id auto_assign ip destination_ip 172.31.0.0 port 1-12 deny
config access_profile profile_id 8 add access_id auto_assign ip destination_ip 192.168.0.0 port 1-12 deny
create access_profile profile_id 9 ip destination_ip_mask 255.0.0.0
config access_profile profile_id 9 add access_id auto_assign ip destination_ip 10.0.0.0 port 1-12 deny
create cpu access_profile profile_id 1 ip vlan
config cpu access_profile profile_id 1 add access_id 1 ip vlan CONTROL port 1-12 permit
create cpu access_profile profile_id 2 ip source_ip_mask 0.0.0.0 icmp type
config cpu access_profile profile_id 2 add access_id 1 ip source_ip 0.0.0.0 icmp type 8 port 1-12 permit
config cpu access_profile profile_id 2 add access_id 2 ip source_ip 0.0.0.0 icmp type 0 port 1-12 permit
config cpu access_profile profile_id 2 add access_id 3 ip source_ip 0.0.0.0 icmp type 3 port 1-12 permit
config cpu access_profile profile_id 2 add access_id 4 ip source_ip 0.0.0.0 icmp type 11 port 1-12 permit
create cpu access_profile profile_id 3 ip udp dst_port_mask 0xFFFF
config cpu access_profile profile_id 3 add access_id 1 ip udp dst_port 53 port 1-9 permit
create cpu access_profile profile_id 4 ip tcp dst_port_mask 0xFFFF
config cpu access_profile profile_id 4 add access_id 1 ip tcp dst_port 53 port 1-9 permit
create cpu access_profile profile_id 5 ip source_ip_mask 0.0.0.0
config cpu access_profile profile_id 5 add access_id 1 ip source_ip 0.0.0.0 port 1-12 deny
enable cpu_interface_filtering

# LIMITED_MULTICAST_RANGE
create multicast_range mcast from 224.0.0.0 to 239.255.255.255

# MULTICAST_VLAN

# FDB
create fdb SNR41 00-14-C2-40-71-69 port 12
create fdb SNR41 00-C0-26-A8-71-01 port 11
create fdb INTERNET 00-1C-C4-48-A5-FC port 10
create fdb CONTROL 00-1E-58-A9-2E-17 port 8
create fdb CONTROL 00-1E-58-A9-2E-1C port 3
create fdb CONTROL 00-1E-58-A9-2E-1D port 2
create fdb CONTROL 00-1E-58-A9-2E-1E port 4
create fdb CONTROL 00-1E-58-A9-2E-39 port 5
create fdb CONTROL 00-1E-58-A9-2E-41 port 5
create fdb CONTROL 00-1E-58-A9-2E-44 port 5
create fdb CONTROL 00-1E-58-A9-2E-50 port 6
create fdb CONTROL 00-1E-58-A9-2E-52 port 7
create fdb CONTROL 00-1E-58-A9-33-94 port 1
create fdb CONTROL 00-24-01-EB-8B-E2 port 9
config fdb aging_time 600

# ADDRBIND
config address_binding ip_mac ports 1-12 forward_dhcppkt enable
disable address_binding dhcp_snoop
disable address_binding trap_log
config address_binding dhcp_snoop max_entry ports 1-12 limit no_limit

# DhcpServerScreening
config filter dhcp_server port all state disable
config filter dhcp_server illegal_server_log_suppress_duration 5min
config filter dhcp_server trap_log disable

# MAC_ADDRESS_TABLE_NOTIFICATION
disable mac_notification
config mac_notification interval 1 historysize 1
config mac_notification ports 1-12 disable

# STP
config stp version rstp
config stp maxage 20 maxhops 20 forwarddelay 15 txholdcount 3 fbpdu disable hellotime 2 lbd enable lbd_recover_timer 60
config stp priority 32768 instance_id 0
config stp mst_config_id name 00:1C:F0:B6:07:00 revision_level 0
disable stp
config stp ports 1-12 externalCost auto edge false p2p auto state enable lbd disable
config stp mst_ports 1-12 instance_id 0 internalCost auto priority 128
config stp ports 1-12 fbpdu disable

# BPDU_TUNNEL
config bpdu_tunnel ports all type none
disable bpdu_tunnel

# SAFEGUARD_ENGINE
config safeguard_engine state enable utilization rising 100 falling 20 trap_log enable mode fuzzy

# BANNER_PROMP
config command_prompt SW41
config greeting_message default

# SSH
config ssh algorithm 3DES enable
config ssh algorithm AES128 enable
config ssh algorithm AES192 enable
config ssh algorithm AES256 enable
config ssh algorithm arcfour enable
config ssh algorithm blowfish enable
config ssh algorithm cast128 enable
config ssh algorithm twofish128 enable
config ssh algorithm twofish192 enable
config ssh algorithm twofish256 enable
config ssh algorithm MD5 enable
config ssh algorithm SHA1 enable
config ssh algorithm RSA enable
config ssh algorithm DSA enable
config ssh authmode password enable
config ssh authmode publickey disable
config ssh authmode hostbased disable
config ssh server maxsession 4
config ssh server contimeout 600
config ssh server authfail 2
config ssh server rekey never
config ssh user admin authmode password
config ssh user klark authmode password
enable ssh

# SNTP
enable sntp
config time_zone operator + hour 3 min 0
config sntp primary 172.16.0.1 secondary 0.0.0.0 poll-interval 720
config dst repeating s_week last s_day sun s_mth 3 s_time 2:0 e_week last e_day sun e_mth 10 e_time 3:0 offset 60

# LACP
config link_aggregation algorithm ip_source
config lacp_port 1-12 mode passive

# IP
config ipif_mac_mapping ipif System mac_offset 0
config ipif System ipaddress 172.31.0.41/24 vlan CONTROL
config ipif System proxy_arp disable local disable
config ipif_mac_mapping ipif gwCNF01 mac_offset 4
create ipif gwCNF01 10.9.1.254/24 CNF01 state enable
config ipif gwCNF01 proxy_arp disable local disable
config ipif_mac_mapping ipif gwFIN12 mac_offset 13
create ipif gwFIN12 10.7.12.254/24 FIN12 state enable
config ipif gwFIN12 proxy_arp disable local disable
config ipif_mac_mapping ipif gwGST01 mac_offset 5
create ipif gwGST01 192.168.1.254/24 GST01 state enable
config ipif gwGST01 proxy_arp disable local disable
config ipif_mac_mapping ipif gwGST11 mac_offset 29
create ipif gwGST11 192.168.11.254/24 GST11 state enable
config ipif gwGST11 proxy_arp disable local disable
config ipif_mac_mapping ipif gwGST21 mac_offset 34
create ipif gwGST21 192.168.21.254/24 GST21 state enable
config ipif gwGST21 proxy_arp disable local disable
config ipif_mac_mapping ipif gwGST22 mac_offset 35
create ipif gwGST22 192.168.22.254/24 GST22 state enable
config ipif gwGST22 proxy_arp disable local disable
config ipif_mac_mapping ipif gwGST31 mac_offset 37
create ipif gwGST31 192.168.31.254/24 GST31 state enable
config ipif gwGST31 proxy_arp disable local disable
config ipif_mac_mapping ipif gwGST32 mac_offset 38
create ipif gwGST32 192.168.32.254/24 GST32 state enable
config ipif gwGST32 proxy_arp disable local disable
config ipif_mac_mapping ipif gwGST42 mac_offset 19
create ipif gwGST42 192.168.42.254/24 GST42 state enable
config ipif gwGST42 proxy_arp disable local disable
config ipif_mac_mapping ipif gwIMD12 mac_offset 32
create ipif gwIMD12 10.4.12.254/24 IMD12 state enable
config ipif gwIMD12 proxy_arp disable local disable
config ipif_mac_mapping ipif gwJSZ32 mac_offset 16
create ipif gwJSZ32 10.8.32.254/24 JSZ32 state enable
config ipif gwJSZ32 proxy_arp disable local disable
config ipif_mac_mapping ipif gwJSZ33 mac_offset 18
create ipif gwJSZ33 10.8.33.254/24 JSZ33 state enable
config ipif gwJSZ33 proxy_arp disable local disable
config ipif_mac_mapping ipif gwMED01 mac_offset 27
create ipif gwMED01 10.2.1.254/24 MED01 state enable
config ipif gwMED01 proxy_arp disable local disable
config ipif_mac_mapping ipif gwMED11 mac_offset 11
create ipif gwMED11 10.2.11.254/24 MED11 state enable
config ipif gwMED11 proxy_arp disable local disable
config ipif_mac_mapping ipif gwMED12 mac_offset 31
create ipif gwMED12 10.2.12.254/24 MED12 state enable
config ipif gwMED12 proxy_arp disable local disable
config ipif_mac_mapping ipif gwMED23 mac_offset 15
create ipif gwMED23 10.2.23.254/24 MED23 state enable
config ipif gwMED23 proxy_arp disable local disable
config ipif_mac_mapping ipif gwMOT12 mac_offset 12
create ipif gwMOT12 10.3.12.254/24 MOT12 state enable
config ipif gwMOT12 proxy_arp disable local disable
config ipif_mac_mapping ipif gwPCCTV mac_offset 21
create ipif gwPCCTV 172.17.0.254/24 PCCTV state enable
config ipif gwPCCTV proxy_arp disable local disable
config ipif_mac_mapping ipif gwSEC01 mac_offset 7
create ipif gwSEC01 10.6.1.254/24 SEC01 state enable
config ipif gwSEC01 proxy_arp disable local disable
config ipif_mac_mapping ipif gwSNR01 mac_offset 3
create ipif gwSNR01 10.0.1.254/24 SNR01 state enable
config ipif gwSNR01 proxy_arp disable local disable
config ipif_mac_mapping ipif gwSNR11 mac_offset 9
create ipif gwSNR11 10.0.11.254/24 SNR11 state enable
config ipif gwSNR11 proxy_arp disable local disable
config ipif_mac_mapping ipif gwSNR41 mac_offset 2
create ipif gwSNR41 10.0.41.254/24 SNR41 state enable
config ipif gwSNR41 proxy_arp disable local disable
config ipif_mac_mapping ipif gwTCH01 mac_offset 8
create ipif gwTCH01 10.5.1.254/24 TCH01 state enable
config ipif gwTCH01 proxy_arp disable local disable
config ipif_mac_mapping ipif gwVIP01 mac_offset 6
create ipif gwVIP01 172.18.1.254/24 VIP01 state enable
config ipif gwVIP01 proxy_arp disable local disable
config ipif_mac_mapping ipif gwVIP11 mac_offset 10
create ipif gwVIP11 172.18.11.254/24 VIP11 state enable
config ipif gwVIP11 proxy_arp disable local disable
config ipif_mac_mapping ipif gwVIP23 mac_offset 14
create ipif gwVIP23 172.18.23.254/24 VIP23 state enable
config ipif gwVIP23 proxy_arp disable local disable
config ipif_mac_mapping ipif gwVIP33 mac_offset 17
create ipif gwVIP33 172.18.33.254/24 VIP33 state enable
config ipif gwVIP33 proxy_arp disable local disable
config ipif_mac_mapping ipif gwVIP42 mac_offset 20
create ipif gwVIP42 172.18.42.254/24 VIP42 state enable
config ipif gwVIP42 proxy_arp disable local disable
config ipif_mac_mapping ipif gwINTERNET mac_offset 1
create ipif gwINTERNET 172.16.0.254/24 INTERNET state enable
config ipif gwINTERNET proxy_arp disable local disable
config ipif System ip_mtu 1500
config ipif gwCNF01 ip_mtu 1500
config ipif gwFIN12 ip_mtu 1500
config ipif gwGST01 ip_mtu 1500
config ipif gwGST11 ip_mtu 1500
config ipif gwGST21 ip_mtu 1500
config ipif gwGST22 ip_mtu 1500
config ipif gwGST31 ip_mtu 1500
config ipif gwGST32 ip_mtu 1500
config ipif gwGST42 ip_mtu 1500
config ipif gwIMD12 ip_mtu 1500
config ipif gwJSZ32 ip_mtu 1500
config ipif gwJSZ33 ip_mtu 1500
config ipif gwMED01 ip_mtu 1500
config ipif gwMED11 ip_mtu 1500
config ipif gwMED12 ip_mtu 1500
config ipif gwMED23 ip_mtu 1500
config ipif gwMOT12 ip_mtu 1500
config ipif gwPCCTV ip_mtu 1500
config ipif gwSEC01 ip_mtu 1500
config ipif gwSNR01 ip_mtu 1500
config ipif gwSNR11 ip_mtu 1500
config ipif gwSNR41 ip_mtu 1500
config ipif gwTCH01 ip_mtu 1500
config ipif gwVIP01 ip_mtu 1500
config ipif gwVIP11 ip_mtu 1500
config ipif gwVIP23 ip_mtu 1500
config ipif gwVIP33 ip_mtu 1500
config ipif gwVIP42 ip_mtu 1500
config ipif gwINTERNET ip_mtu 1500
disable autoconfig

# LLDP
disable lldp
config lldp message_tx_interval 30
config lldp tx_delay 2
config lldp message_tx_hold_multiplier 4
config lldp reinit_delay 2
config lldp notification_interval 5
config lldp ports 1-12 notification disable
config lldp ports 1-12 admin_status tx_and_rx

# MBA
disable mac_based_access_control
config mac_based_access_control ports 1-12 state disable
config mac_based_access_control ports 1-12 mode host_based
config mac_based_access_control method local
config mac_based_access_control password default

# MCFILTER
config multicast filtering_mode default filter_unregistered_groups
config multicast filtering_mode GST01 filter_unregistered_groups
config multicast filtering_mode GST11 filter_unregistered_groups
config multicast filtering_mode GST21 filter_unregistered_groups
config multicast filtering_mode GST22 filter_unregistered_groups
config multicast filtering_mode GST31 filter_unregistered_groups
config multicast filtering_mode GST32 filter_unregistered_groups
config multicast filtering_mode GST42 filter_unregistered_groups
config multicast filtering_mode MED01 filter_unregistered_groups
config multicast filtering_mode MED11 filter_unregistered_groups
config multicast filtering_mode MED12 filter_unregistered_groups
config multicast filtering_mode MED23 filter_unregistered_groups
config multicast filtering_mode MOT12 filter_unregistered_groups
config multicast filtering_mode IMD12 filter_unregistered_groups
config multicast filtering_mode TCH01 filter_unregistered_groups
config multicast filtering_mode SEC01 filter_unregistered_groups
config multicast filtering_mode FIN12 filter_unregistered_groups
config multicast filtering_mode JSZ32 filter_unregistered_groups
config multicast filtering_mode JSZ33 filter_unregistered_groups
config multicast filtering_mode CNF01 filter_unregistered_groups
config multicast filtering_mode VIP01 filter_unregistered_groups
config multicast filtering_mode VIP11 filter_unregistered_groups
config multicast filtering_mode VIP23 filter_unregistered_groups
config multicast filtering_mode VIP33 filter_unregistered_groups
config multicast filtering_mode VIP42 filter_unregistered_groups
config multicast filtering_mode SNR01 filter_unregistered_groups
config multicast filtering_mode SNR11 filter_unregistered_groups
config multicast filtering_mode SNR41 filter_unregistered_groups
config multicast filtering_mode PCCTV filter_unregistered_groups
config multicast filtering_mode INTERNET filter_unregistered_groups
config multicast filtering_mode CONTROL filter_unregistered_groups

# SNOOP
enable igmp_snooping
config igmp_snooping vlan default state disable fast_leave disable
config igmp_snooping querier vlan default query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan GST01 state disable fast_leave disable
config igmp_snooping querier vlan GST01 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan GST11 state disable fast_leave disable
config igmp_snooping querier vlan GST11 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan GST21 state disable fast_leave disable
config igmp_snooping querier vlan GST21 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan GST22 state disable fast_leave disable
config igmp_snooping querier vlan GST22 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan GST31 state disable fast_leave disable
config igmp_snooping querier vlan GST31 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan GST32 state disable fast_leave disable
config igmp_snooping querier vlan GST32 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan GST42 state disable fast_leave disable
config igmp_snooping querier vlan GST42 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan MED01 state disable fast_leave disable
config igmp_snooping querier vlan MED01 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan MED11 state disable fast_leave disable
config igmp_snooping querier vlan MED11 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan MED12 state disable fast_leave disable
config igmp_snooping querier vlan MED12 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan MED23 state disable fast_leave disable
config igmp_snooping querier vlan MED23 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan MOT12 state disable fast_leave disable
config igmp_snooping querier vlan MOT12 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan IMD12 state disable fast_leave disable
config igmp_snooping querier vlan IMD12 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan TCH01 state disable fast_leave disable
config igmp_snooping querier vlan TCH01 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan SEC01 state disable fast_leave disable
config igmp_snooping querier vlan SEC01 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan FIN12 state disable fast_leave disable
config igmp_snooping querier vlan FIN12 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan JSZ32 state disable fast_leave disable
config igmp_snooping querier vlan JSZ32 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan JSZ33 state disable fast_leave disable
config igmp_snooping querier vlan JSZ33 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan CNF01 state disable fast_leave disable
config igmp_snooping querier vlan CNF01 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan VIP01 state disable fast_leave disable
config igmp_snooping querier vlan VIP01 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan VIP11 state disable fast_leave disable
config igmp_snooping querier vlan VIP11 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan VIP23 state disable fast_leave disable
config igmp_snooping querier vlan VIP23 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan VIP33 state disable fast_leave disable
config igmp_snooping querier vlan VIP33 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan VIP42 state disable fast_leave disable
config igmp_snooping querier vlan VIP42 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan SNR01 state disable fast_leave disable
config igmp_snooping querier vlan SNR01 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan SNR11 state disable fast_leave disable
config igmp_snooping querier vlan SNR11 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan SNR41 state disable fast_leave disable
config igmp_snooping querier vlan SNR41 query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan PCCTV state disable fast_leave disable
config igmp_snooping querier vlan PCCTV query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan INTERNET state disable fast_leave disable
config igmp_snooping querier vlan INTERNET query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config igmp_snooping vlan CONTROL state disable fast_leave disable
config igmp_snooping querier vlan CONTROL query_interval 125 max_response_time 10 robustness_variable 2 last_member_query_interval 1 state disable version 3
config router_ports_forbidden GST01 add 1
config router_ports_forbidden GST11 add 2
config router_ports_forbidden GST21 add 5
config router_ports_forbidden GST22 add 5
config router_ports_forbidden GST31 add 5
config router_ports_forbidden GST32 add 6
config router_ports_forbidden GST42 add 8
config router_ports_forbidden MED01 add 1
config router_ports_forbidden MED11 add 2
config router_ports_forbidden MED12 add 3
config router_ports_forbidden MED23 add 4
config router_ports_forbidden MOT12 add 3
config router_ports_forbidden IMD12 add 3
config router_ports_forbidden TCH01 add 1
config router_ports_forbidden SEC01 add 1
config router_ports_forbidden FIN12 add 3
config router_ports_forbidden JSZ32 add 6
config router_ports_forbidden JSZ33 add 7
config router_ports_forbidden CNF01 add 1
config router_ports_forbidden VIP01 add 1
config router_ports_forbidden VIP11 add 2
config router_ports_forbidden VIP23 add 4
config router_ports_forbidden VIP33 add 7
config router_ports_forbidden VIP42 add 8
config router_ports_forbidden SNR01 add 1
config router_ports_forbidden SNR11 add 2
config router_ports_forbidden SNR41 add 11-12
config router_ports_forbidden PCCTV add 9
config router_ports_forbidden INTERNET add 10
config limited_multicast_addr ports 1-12 add multicast_range mcast
config limited_multicast_addr ports 1-12 access deny state enable

# MLDSNP

# ACCESS_AUTHENTICATION_CONTROL
config authen_login default method local
config authen_enable default method local_enable
config authen application console login default
config authen application console enable default
config authen application telnet login default
config authen application telnet enable default
config authen application ssh login default
config authen application ssh enable default
config authen application http login default
config authen application http enable default
config authen parameter response_timeout 30
config authen parameter attempt 3
disable authen_policy

# AAA_LOCAL_ENABLE_PASSWORD

# NDP
config ipv6 nd ns ipif System retrans_time 0
config ipv6 nd ra ipif System state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwINTERNET retrans_time 0
config ipv6 nd ra ipif gwINTERNET state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwSNR41 retrans_time 0
config ipv6 nd ra ipif gwSNR41 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwGST21 retrans_time 0
config ipv6 nd ra ipif gwGST21 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwGST22 retrans_time 0
config ipv6 nd ra ipif gwGST22 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwSNR01 retrans_time 0
config ipv6 nd ra ipif gwSNR01 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwMED01 retrans_time 0
config ipv6 nd ra ipif gwMED01 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwCNF01 retrans_time 0
config ipv6 nd ra ipif gwCNF01 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwGST01 retrans_time 0
config ipv6 nd ra ipif gwGST01 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwVIP01 retrans_time 0
config ipv6 nd ra ipif gwVIP01 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwSEC01 retrans_time 0
config ipv6 nd ra ipif gwSEC01 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwTCH01 retrans_time 0
config ipv6 nd ra ipif gwTCH01 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwSNR11 retrans_time 0
config ipv6 nd ra ipif gwSNR11 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwGST11 retrans_time 0
config ipv6 nd ra ipif gwGST11 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwVIP11 retrans_time 0
config ipv6 nd ra ipif gwVIP11 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwMED11 retrans_time 0
config ipv6 nd ra ipif gwMED11 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwMED12 retrans_time 0
config ipv6 nd ra ipif gwMED12 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwIMD12 retrans_time 0
config ipv6 nd ra ipif gwIMD12 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwMOT12 retrans_time 0
config ipv6 nd ra ipif gwMOT12 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwFIN12 retrans_time 0
config ipv6 nd ra ipif gwFIN12 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwVIP23 retrans_time 0
config ipv6 nd ra ipif gwVIP23 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwMED23 retrans_time 0
config ipv6 nd ra ipif gwMED23 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwGST31 retrans_time 0
config ipv6 nd ra ipif gwGST31 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwGST32 retrans_time 0
config ipv6 nd ra ipif gwGST32 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwJSZ32 retrans_time 0
config ipv6 nd ra ipif gwJSZ32 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwVIP33 retrans_time 0
config ipv6 nd ra ipif gwVIP33 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwJSZ33 retrans_time 0
config ipv6 nd ra ipif gwJSZ33 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwGST42 retrans_time 0
config ipv6 nd ra ipif gwGST42 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwVIP42 retrans_time 0
config ipv6 nd ra ipif gwVIP42 state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600
config ipv6 nd ns ipif gwPCCTV retrans_time 0
config ipv6 nd ra ipif gwPCCTV state disable life_time 1800 reachable_time 1200000 retrans_time 0 hop_limit 64 managed_flag disable other_config_flag disable min_rtr_adv_interval 198 max_rtr_adv_interval 600

# WAC
config wac method local
disable wac

# ARP
create arpentry 172.31.0.1 00-1E-58-A9-33-94
create arpentry 172.31.0.11 00-1E-58-A9-2E-1D
create arpentry 172.31.0.12 00-1E-58-A9-2E-1C
create arpentry 172.31.0.21 00-1E-58-A9-2E-39
create arpentry 172.31.0.22 00-1E-58-A9-2E-41
create arpentry 172.31.0.23 00-1E-58-A9-2E-1E
create arpentry 172.31.0.31 00-1E-58-A9-2E-44
create arpentry 172.31.0.32 00-1E-58-A9-2E-50
create arpentry 172.31.0.33 00-1E-58-A9-2E-52
create arpentry 172.31.0.42 00-1E-58-A9-2E-17
create arpentry 172.31.0.43 00-24-01-EB-8B-E2
create arpentry 172.16.0.1 00-1C-C4-48-A5-FC
create arpentry 10.0.41.11 00-C0-26-A8-71-01
create arpentry 10.0.41.12 00-14-C2-40-71-69
config arp_aging time 600
config gratuitous_arp send ipif_status_up disable
config gratuitous_arp send dup_ip_detected disable
config gratuitous_arp learning disable

# ROUTE
config route preference static 60
config route preference rip 100
config route preference ospfIntra 80
config route preference ospfInter 90
config route preference ospfExt1 110
config route preference ospfExt2 115
create iproute default 172.16.0.1 1 primary
config ecmp algorithm ip_destination crc_low
enable ecmp ospf

# PROUTE

# IGMP
config igmp ipif System version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif System last_member_query_interval 1
config igmp ipif gwINTERNET version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwINTERNET last_member_query_interval 1
config igmp ipif gwSNR41 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwSNR41 last_member_query_interval 1
config igmp ipif gwGST21 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwGST21 last_member_query_interval 1
config igmp ipif gwGST22 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwGST22 last_member_query_interval 1
config igmp ipif gwSNR01 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwSNR01 last_member_query_interval 1
config igmp ipif gwMED01 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwMED01 last_member_query_interval 1
config igmp ipif gwCNF01 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwCNF01 last_member_query_interval 1
config igmp ipif gwGST01 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwGST01 last_member_query_interval 1
config igmp ipif gwVIP01 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwVIP01 last_member_query_interval 1
config igmp ipif gwSEC01 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwSEC01 last_member_query_interval 1
config igmp ipif gwTCH01 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwTCH01 last_member_query_interval 1
config igmp ipif gwSNR11 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwSNR11 last_member_query_interval 1
config igmp ipif gwGST11 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwGST11 last_member_query_interval 1
config igmp ipif gwVIP11 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwVIP11 last_member_query_interval 1
config igmp ipif gwMED11 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwMED11 last_member_query_interval 1
config igmp ipif gwMED12 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwMED12 last_member_query_interval 1
config igmp ipif gwIMD12 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwIMD12 last_member_query_interval 1
config igmp ipif gwMOT12 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwMOT12 last_member_query_interval 1
config igmp ipif gwFIN12 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwFIN12 last_member_query_interval 1
config igmp ipif gwVIP23 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwVIP23 last_member_query_interval 1
config igmp ipif gwMED23 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwMED23 last_member_query_interval 1
config igmp ipif gwGST31 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwGST31 last_member_query_interval 1
config igmp ipif gwGST32 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwGST32 last_member_query_interval 1
config igmp ipif gwJSZ32 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwJSZ32 last_member_query_interval 1
config igmp ipif gwVIP33 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwVIP33 last_member_query_interval 1
config igmp ipif gwJSZ33 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwJSZ33 last_member_query_interval 1
config igmp ipif gwGST42 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwGST42 last_member_query_interval 1
config igmp ipif gwVIP42 version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwVIP42 last_member_query_interval 1
config igmp ipif gwPCCTV version 3 query_interval 125 max_response_time 10 robustness_variable 2 state disable
config igmp ipif gwPCCTV last_member_query_interval 1

# PIMSM
disable pim
config pim cbsr hash_masklen 30
config pim cbsr bootstrap_period 60
config pim register_suppression_time 60
config pim register_probe_time 5
config pim last_hop_spt_switchover never
config pim crp holdtime 150 priority 192
config pim crp wildcard_prefix_cnt 0
config pim ipif System state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif System priority -1
config pim ipif gwINTERNET state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwINTERNET priority -1
config pim ipif gwSNR41 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwSNR41 priority -1
config pim ipif gwGST21 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwGST21 priority -1
config pim ipif gwGST22 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwGST22 priority -1
config pim ipif gwSNR01 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwSNR01 priority -1
config pim ipif gwMED01 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwMED01 priority -1
config pim ipif gwCNF01 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwCNF01 priority -1
config pim ipif gwGST01 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwGST01 priority -1
config pim ipif gwVIP01 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwVIP01 priority -1
config pim ipif gwSEC01 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwSEC01 priority -1
config pim ipif gwTCH01 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwTCH01 priority -1
config pim ipif gwSNR11 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwSNR11 priority -1
config pim ipif gwGST11 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwGST11 priority -1
config pim ipif gwVIP11 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwVIP11 priority -1
config pim ipif gwMED11 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwMED11 priority -1
config pim ipif gwMED12 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwMED12 priority -1
config pim ipif gwIMD12 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwIMD12 priority -1
config pim ipif gwMOT12 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwMOT12 priority -1
config pim ipif gwFIN12 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwFIN12 priority -1
config pim ipif gwVIP23 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwVIP23 priority -1
config pim ipif gwMED23 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwMED23 priority -1
config pim ipif gwGST31 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwGST31 priority -1
config pim ipif gwGST32 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwGST32 priority -1
config pim ipif gwJSZ32 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwJSZ32 priority -1
config pim ipif gwVIP33 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwVIP33 priority -1
config pim ipif gwJSZ33 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwJSZ33 priority -1
config pim ipif gwGST42 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwGST42 priority -1
config pim ipif gwVIP42 state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwVIP42 priority -1
config pim ipif gwPCCTV state disable hello 30 jp_interval 60 mode dm dr_priority 1
config pim cbsr ipif gwPCCTV priority -1

# DVMRP
disable dvmrp
config dvmrp ipif System metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwINTERNET metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwSNR41 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwGST21 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwGST22 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwSNR01 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwMED01 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwCNF01 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwGST01 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwVIP01 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwSEC01 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwTCH01 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwSNR11 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwGST11 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwVIP11 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwMED11 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwMED12 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwIMD12 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwMOT12 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwFIN12 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwVIP23 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwMED23 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwGST31 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwGST32 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwJSZ32 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwVIP33 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwJSZ33 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwGST42 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwVIP42 metric 1 probe 10 neighbor_timeout 35 state disable
config dvmrp ipif gwPCCTV metric 1 probe 10 neighbor_timeout 35 state disable

# IPMROUTE

# RIP
disable rip
config rip ipif System tx_mode disable state disable
config rip ipif System rx_mode disable state disable
config rip ipif gwINTERNET tx_mode disable state disable
config rip ipif gwINTERNET rx_mode disable state disable
config rip ipif gwSNR41 tx_mode disable state disable
config rip ipif gwSNR41 rx_mode disable state disable
config rip ipif gwGST21 tx_mode disable state disable
config rip ipif gwGST21 rx_mode disable state disable
config rip ipif gwGST22 tx_mode disable state disable
config rip ipif gwGST22 rx_mode disable state disable
config rip ipif gwSNR01 tx_mode disable state disable
config rip ipif gwSNR01 rx_mode disable state disable
config rip ipif gwMED01 tx_mode disable state disable
config rip ipif gwMED01 rx_mode disable state disable
config rip ipif gwCNF01 tx_mode disable state disable
config rip ipif gwCNF01 rx_mode disable state disable
config rip ipif gwGST01 tx_mode disable state disable
config rip ipif gwGST01 rx_mode disable state disable
config rip ipif gwVIP01 tx_mode disable state disable
config rip ipif gwVIP01 rx_mode disable state disable
config rip ipif gwSEC01 tx_mode disable state disable
config rip ipif gwSEC01 rx_mode disable state disable
config rip ipif gwTCH01 tx_mode disable state disable
config rip ipif gwTCH01 rx_mode disable state disable
config rip ipif gwSNR11 tx_mode disable state disable
config rip ipif gwSNR11 rx_mode disable state disable
config rip ipif gwGST11 tx_mode disable state disable
config rip ipif gwGST11 rx_mode disable state disable
config rip ipif gwVIP11 tx_mode disable state disable
config rip ipif gwVIP11 rx_mode disable state disable
config rip ipif gwMED11 tx_mode disable state disable
config rip ipif gwMED11 rx_mode disable state disable
config rip ipif gwMED12 tx_mode disable state disable
config rip ipif gwMED12 rx_mode disable state disable
config rip ipif gwIMD12 tx_mode disable state disable
config rip ipif gwIMD12 rx_mode disable state disable
config rip ipif gwMOT12 tx_mode disable state disable
config rip ipif gwMOT12 rx_mode disable state disable
config rip ipif gwFIN12 tx_mode disable state disable
config rip ipif gwFIN12 rx_mode disable state disable
config rip ipif gwVIP23 tx_mode disable state disable
config rip ipif gwVIP23 rx_mode disable state disable
config rip ipif gwMED23 tx_mode disable state disable
config rip ipif gwMED23 rx_mode disable state disable
config rip ipif gwGST31 tx_mode disable state disable
config rip ipif gwGST31 rx_mode disable state disable
config rip ipif gwGST32 tx_mode disable state disable
config rip ipif gwGST32 rx_mode disable state disable
config rip ipif gwJSZ32 tx_mode disable state disable
config rip ipif gwJSZ32 rx_mode disable state disable
config rip ipif gwVIP33 tx_mode disable state disable
config rip ipif gwVIP33 rx_mode disable state disable
config rip ipif gwJSZ33 tx_mode disable state disable
config rip ipif gwJSZ33 rx_mode disable state disable
config rip ipif gwGST42 tx_mode disable state disable
config rip ipif gwGST42 rx_mode disable state disable
config rip ipif gwVIP42 tx_mode disable state disable
config rip ipif gwVIP42 rx_mode disable state disable
config rip ipif gwPCCTV tx_mode disable state disable
config rip ipif gwPCCTV rx_mode disable state disable

# MD5

# SFLOW

# OSPF
config ospf ipif gwSNR01 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwSNR01 authentication none metric 1 state disable passive disable
config ospf ipif gwSNR11 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwSNR11 authentication none metric 1 state disable passive disable
config ospf ipif gwSNR41 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwSNR41 authentication none metric 1 state disable passive disable
config ospf ipif gwMED01 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwMED01 authentication none metric 1 state disable passive disable
config ospf ipif gwMED11 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwMED11 authentication none metric 1 state disable passive disable
config ospf ipif gwMED12 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwMED12 authentication none metric 1 state disable passive disable
config ospf ipif gwMED23 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwMED23 authentication none metric 1 state disable passive disable
config ospf ipif gwMOT12 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwMOT12 authentication none metric 1 state disable passive disable
config ospf ipif gwIMD12 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwIMD12 authentication none metric 1 state disable passive disable
config ospf ipif gwTCH01 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwTCH01 authentication none metric 1 state disable passive disable
config ospf ipif gwSEC01 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwSEC01 authentication none metric 1 state disable passive disable
config ospf ipif gwFIN12 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwFIN12 authentication none metric 1 state disable passive disable
config ospf ipif gwJSZ32 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwJSZ32 authentication none metric 1 state disable passive disable
config ospf ipif gwJSZ33 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwJSZ33 authentication none metric 1 state disable passive disable
config ospf ipif gwCNF01 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwCNF01 authentication none metric 1 state disable passive disable
config ospf ipif gwINTERNET area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwINTERNET authentication none metric 1 state disable passive disable
config ospf ipif gwPCCTV area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwPCCTV authentication none metric 1 state disable passive disable
config ospf ipif gwVIP01 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwVIP01 authentication none metric 1 state disable passive disable
config ospf ipif gwVIP11 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwVIP11 authentication none metric 1 state disable passive disable
config ospf ipif gwVIP23 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwVIP23 authentication none metric 1 state disable passive disable
config ospf ipif gwVIP33 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwVIP33 authentication none metric 1 state disable passive disable
config ospf ipif gwVIP42 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwVIP42 authentication none metric 1 state disable passive disable
config ospf ipif System area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif System authentication none metric 1 state disable passive disable
config ospf ipif gwGST01 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwGST01 authentication none metric 1 state disable passive disable
config ospf ipif gwGST11 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwGST11 authentication none metric 1 state disable passive disable
config ospf ipif gwGST21 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwGST21 authentication none metric 1 state disable passive disable
config ospf ipif gwGST22 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwGST22 authentication none metric 1 state disable passive disable
config ospf ipif gwGST31 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwGST31 authentication none metric 1 state disable passive disable
config ospf ipif gwGST32 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwGST32 authentication none metric 1 state disable passive disable
config ospf ipif gwGST42 area 0.0.0.0 priority 1 hello_interval 10 dead_interval 40
config ospf ipif gwGST42 authentication none metric 1 state disable passive disable
config ospf router_id 0.0.0.0
disable ospf

# DNSR
enable dnsr
config dnsr primary nameserver 10.0.41.12
config dnsr secondary nameserver 172.16.1.1
enable dnsr cache
enable dnsr static

# DHCP_RELAY
disable dhcp_relay
config dhcp_relay hops 4 time 0
config dhcp_relay option_82 state disable
config dhcp_relay option_82 check disable
config dhcp_relay option_82 policy replace

# DHCP_SERVER
config dhcp ping_packets 2
config dhcp ping_timeout 500
disable dhcp_server

# VRRP
config vrrp ipif System authtype none
config vrrp ipif gwINTERNET authtype none
config vrrp ipif gwSNR41 authtype none
config vrrp ipif gwGST21 authtype none
config vrrp ipif gwGST22 authtype none
config vrrp ipif gwSNR01 authtype none
config vrrp ipif gwMED01 authtype none
config vrrp ipif gwCNF01 authtype none
config vrrp ipif gwGST01 authtype none
config vrrp ipif gwVIP01 authtype none
config vrrp ipif gwSEC01 authtype none
config vrrp ipif gwTCH01 authtype none
config vrrp ipif gwSNR11 authtype none
config vrrp ipif gwGST11 authtype none
config vrrp ipif gwVIP11 authtype none
config vrrp ipif gwMED11 authtype none
config vrrp ipif gwMED12 authtype none
config vrrp ipif gwIMD12 authtype none
config vrrp ipif gwMOT12 authtype none
config vrrp ipif gwFIN12 authtype none
config vrrp ipif gwVIP23 authtype none
config vrrp ipif gwMED23 authtype none
config vrrp ipif gwGST31 authtype none
config vrrp ipif gwGST32 authtype none
config vrrp ipif gwJSZ32 authtype none
config vrrp ipif gwVIP33 authtype none
config vrrp ipif gwJSZ33 authtype none
config vrrp ipif gwGST42 authtype none
config vrrp ipif gwVIP42 authtype none
config vrrp ipif gwPCCTV authtype none
disable vrrp

disable vrrp ping

#-------------------------------------------------------------------
#             End of configuration file for DGS-3612
# Switch 'SW41' configuration saved at Mon, 24 May 10 12:14:16 +0400
#-------------------------------------------------------------------

