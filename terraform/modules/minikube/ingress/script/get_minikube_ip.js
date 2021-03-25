const shell = require('../../../node_modules/shelljs');
//-------------script args params---------------------//

const get_minikube_ip = (command) => {
  try {
    const { stdout, stderr, code } = shell.exec(command, { silent: true });
    if (code !== 0) {
      process.stderr.write(
        Buffer.from(
          JSON.stringify({
            error: `[get_minikube_ip]:${stderr}: ${code}`,
          })
        )
      );
      process.exit(1);
    }
    process.stdout.write(
      Buffer.from(
        JSON.stringify({
          minikube_ip: stdout.trim(),
        })
      )
    );
  } catch (err) {
    process.stderr.write(
      Buffer.from(
        JSON.stringify({
          error: `[get_minikube_ip]${err}`,
        })
      )
    );
    process.exit(1);
  }
};

const main = async () => {
  const command = `minikube ip`;
  //---> Wait 10 sec and execute
  setTimeout(() => get_minikube_ip(command), 10000);
};

main();
