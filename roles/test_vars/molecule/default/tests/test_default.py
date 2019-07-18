import os
import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_vars(host):
    vars = host.ansible("debug", "var=vars_")

    # ..seealso:: roles/test_vars/defaults/main.yml
    assert vars.get('a', None) == 0, repr(vars)
    assert vars.get('b', False) == 'bbb', repr(vars)
    assert vars.get('c', False) == [1, 2, 3]
