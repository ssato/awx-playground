import os.path
import os
import testinfra.utils.ansible_runner


testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_facts(host):
    vars = host.ansible.get_variables()
    assert vars
    assert vars.get('a', False)
    assert vars.get('b', False)
    assert vars.get('c', False)
