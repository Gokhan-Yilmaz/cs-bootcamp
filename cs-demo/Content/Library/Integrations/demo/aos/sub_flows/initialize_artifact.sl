namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host: 10.0.46.31
    - username: root
    - password: admin@123
    - artifact_url:
        required: false
    - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
    - parameters:
        required: false
  workflow:
    - is_artifact_given:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy: []
        publish:
          - artifact_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy: []
        publish:
          - script_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_file
          - FAILURE: on_failure
    - has_failed:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(command_return_code == '0')}"
        publish: []
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
    - delete_file:
        do:
          Integrations.demo.aos.tools.delete_file: []
        navigate:
          - FAILURE: has_failed
          - SUCCESS: has_failed
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_artifact_given:
        x: 503
        y: 6
      copy_artifact:
        x: 313
        y: 179
        navigate:
          df952e7d-8dfb-6849-27f2-c58037c62323:
            vertices:
              - x: 318
                y: 243
            targetId: execute_script
            port: SUCCESS
      copy_script:
        x: 659
        y: 172
        navigate:
          0885621c-04a2-0e3a-736b-b4b9322061f7:
            vertices:
              - x: 518
                y: 272
            targetId: execute_script
            port: SUCCESS
      execute_script:
        x: 130
        y: 316
      has_failed:
        x: 566
        y: 380
        navigate:
          f5d6e674-2e28-000d-d103-2444833ae7ec:
            targetId: 8b65b8bf-8a79-c927-3219-235072b3d544
            port: 'TRUE'
          2465b9bd-7232-d143-f24d-b19ce328a292:
            targetId: 7cd61370-f5c8-cb1d-81a3-cc4c7bd4afb7
            port: 'FALSE'
      delete_file:
        x: 307
        y: 403
    results:
      FAILURE:
        7cd61370-f5c8-cb1d-81a3-cc4c7bd4afb7:
          x: 696
          y: 545
      SUCCESS:
        8b65b8bf-8a79-c927-3219-235072b3d544:
          x: 695
          y: 390
