const fs = require('fs');
const shell = require('../modules/node_modules/shelljs');

const get_inputs = () => {
  try {
    const inputs = {};
    inputs.destroy_environment = JSON.parse(process.argv[2]);

    inputs.plan_name = 'test.plan';
    return inputs;
  } catch (err) {
    console.error(`[get_inputs error] error: ${err}`);
    process.exit(1);
  }
};

const init_terraform = () => {
  try {
    if (shell.exec(`terraform init`).code !== 0) {
      throw new Error('init_terraform error');
    }
  } catch (err) {
    console.error(`[init_terraform error] error: ${err}`);
    process.exit(1);
  }
};

const plan_terraform = (plan_name) => {
  try {
    if (shell.exec(`terraform plan -out ${plan_name}`).code !== 0) {
      throw new Error('plan_terraform error');
    }
  } catch (err) {
    console.error(`[plan_terraform error] error: ${err}`);
    process.exit(1);
  }
};

const apply_terraform = (plan_name) => {
  try {
    const { stdout, stderr, code } = shell.exec(`terraform apply ${plan_name}`);
    if (code !== 0) {
      if (
        stderr.includes('Unauthorized') ||
        stderr.includes('Kubernetes cluster unreachable')
      ) {
        console.log(`error : [${stderr}] -- Retrying one more time...`);
        init_terraform();
        plan_terraform(plan_name);
        apply_terraform(plan_name);
      } else {
        throw new Error('apply_terraform error');
      }
    }
  } catch (err) {
    console.error(`[apply_terraform error] error: ${err}`);
    process.exit(1);
  }
};

const destroy_terraform = () => {
  try {
    if (shell.exec(`terraform destroy -auto-approve`).code !== 0) {
      throw new Error('destroy_terraform error');
    }
  } catch (err) {
    console.error(`[destroy_terraform error] error: ${err}`);
    process.exit(1);
  }
};

const main = async () => {
  try {
    //---> Get script inputs
    const inputs = get_inputs();
    //---> Init terraform
    init_terraform();
    //---> Destroy/Deploy
    if (!inputs.destroy_environment) {
      plan_terraform(inputs.plan_name);
      apply_terraform(inputs.plan_name);
    } else {
      destroy_terraform();
    }
  } catch (err) {
    console.error(`[main error] error: ${err}`);
  }
};

main();

//---> node init_flow.js "true | false"
