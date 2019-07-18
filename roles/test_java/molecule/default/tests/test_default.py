# References:
# - https://testinfra.readthedocs.io
# - https://github.com/dwalleck/testinfra-by-example/
#

import os.path
import os
import testinfra.utils.ansible_runner


testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_facts(host):
    vars = host.ansible.get_variables()
    assert vars

    assert host.exists("java")

    # a.
    jvc_s = "java -version"
    jvc = host.run(jvc_s)

    assert jvc.rc == 0
    assert jvc.stdout == ''
    assert jvc.stderr
    assert "1.8" in jvc.stderr

    # b.
    host.run_expect([0], jvc_s)

# vim:et:
