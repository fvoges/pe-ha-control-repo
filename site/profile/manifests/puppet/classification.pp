# class profile::puppet::classification
class profile::puppet::classification {

  node_group { 'Agent-specified environment':
    ensure               => 'present',
    environment          => 'agent-specified',
    override_environment => true,
    parent               => 'Production environment',
  }

  node_group { 'All Nodes':
    ensure               => 'present',
    environment          => 'production',
    override_environment => false,
    rule                 => ['and', ['~', 'name', '.*']],
  }

  node_group { 'PE ActiveMQ Broker':
    ensure               => 'present',
    classes              => {
      'puppet_enterprise::profile::amq::broker' => {},
    },
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
    rule                 => [
      'or',
        ['=', 'name', 'mom01.puppetdebug.vlan'],
    ],
  }

  node_group { 'PE Agent':
    ensure               => 'present',
    classes              => {
      'puppet_enterprise::profile::agent' => {},
    },
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
    rule                 => [
      'and',
        ['~', ['fact', 'aio_agent_version'], '.+'],
    ],
  }

  node_group { 'PE Certificate Authority':
    ensure               => 'present',
    classes              => {
      'puppet_enterprise::profile::certificate_authority' => {},
    },
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
    rule                 => ['or',
      ['=', 'name', 'mom01.puppetdebug.vlan'],
    ],
  }

  node_group { 'PE Console':
    ensure               => 'present',
    classes              => {
      'puppet_enterprise::license'          => {},
      'puppet_enterprise::profile::console' => {},
    },
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
    rule                 => ['or', ['=', 'name', 'mom01.puppetdebug.vlan']],
  }

  node_group { 'PE Infrastructure':
    ensure               => 'present',
    classes              => {
      'puppet_enterprise' => {
        'certificate_authority_host'   => 'mom01.puppetdebug.vlan',
        'console_host'                 => 'mom01.puppetdebug.vlan',
        'database_host'                => 'mom01.puppetdebug.vlan',
        'mcollective_middleware_hosts' => ['mom01.puppetdebug.vlan'],
        'pcp_broker_host'              => 'mom01.puppetdebug.vlan',
        'puppet_master_host'           => 'mom01.puppetdebug.vlan',
        'puppetdb_host'                => 'mom01.puppetdebug.vlan',
      },
    },
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
  }

  node_group { 'PE Infrastructure Agent':
    ensure               => 'present',
    classes              => {
      'puppet_enterprise::profile::agent' => {},
    },
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Agent',
    rule                 => ['and', ['~', ['fact', 'pe_server_version'], '.+']],
  }

  node_group { 'PE MCollective':
    ensure               => 'present',
    classes              => {
      'puppet_enterprise::profile::mcollective::agent' => {},
    },
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
    rule                 => ['and', ['~', ['fact', 'aio_agent_version'], '.+']],
  }

  node_group { 'PE Master':
    ensure               => 'present',
    classes              => {
      'pe_repo'                                          => {},
      'pe_repo::platform::el_6_x86_64'                   => {},
      'pe_repo::platform::el_7_x86_64'                   => {},
      'puppet_enterprise::profile::master'               => {
        'code_manager_auto_configure' => true,
        'r10k_remote'                 => 'https://github.com/fvoges/pe-ha-control-repo.git',
      },
      'puppet_enterprise::profile::master::mcollective'  => {},
      'puppet_enterprise::profile::mcollective::peadmin' => {},
    },
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
    rule                 => [
      'or',
        [ 'and',
          ['=', ['trusted', 'extensions', 'pp_application'], 'puppet'],
          ['=', ['trusted', 'extensions', 'pp_role'], 'compile'],
        ],
        ['=', 'name', 'mom01.puppetdebug.vlan'],
    ],
  }

  node_group { 'PE Orchestrator':
    ensure               => 'present',
    classes              => {
      'puppet_enterprise::profile::orchestrator' => {},
    },
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
    rule                 => [
      'or',
        ['=', 'name', 'mom01.puppetdebug.vlan'],
    ],
  }

  node_group { 'PE PuppetDB':
    ensure               => 'present',
    classes              => {
      'puppet_enterprise::profile::puppetdb' => {},
    },
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
    rule                 => ['or', ['=', 'name', 'mom01.puppetdebug.vlan']],
  }

  node_group { 'Production environment':
    ensure               => 'present',
    environment          => 'production',
    override_environment => true,
    parent               => 'All Nodes',
    rule                 => ['and', ['~', 'name', '.*']],
  }

  node_group { 'Role: Puppet MOM':
    ensure               => 'present',
    classes              => {
      'role::puppet::mom' => {},
    },
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => [
      'and',
        ['=', ['trusted', 'extensions', 'pp_role'], 'mom'],
        ['=', ['trusted', 'extensions', 'pp_application'], 'puppet'],
    ],
  }

  node_group { 'Role: Puppet LB':
    ensure               => 'present',
    classes              => {
      'role::puppet::lb' => {},
    },
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => [
      'and',
        ['=', ['trusted', 'extensions', 'pp_role'], 'lb'],
        ['=', ['trusted', 'extensions', 'pp_application'], 'puppet'],
    ],
  }

  node_group { 'Role: Puppet Compile Master':
    ensure               => 'present',
    classes              => {
      'role::puppet::compile' => {},
    },
    environment          => 'production',
    override_environment => false,
    parent               => 'All Nodes',
    rule                 => [
      'and',
        ['=', ['trusted', 'extensions', 'pp_role'], 'compile'],
        ['=', ['trusted', 'extensions', 'pp_application'], 'puppet']
      ],
  }

  node_group { 'PE ActiveMQ Hub':
    ensure               => 'present',
    classes              => {
      'puppet_enterprise::profile::amq::hub' => {},
    },
    environment          => 'production',
    override_environment => false,
    parent               => 'PE Infrastructure',
    # rule                 => ['or', ['=', 'name', 'mom01.puppetdebug.vlan']],
  }
}