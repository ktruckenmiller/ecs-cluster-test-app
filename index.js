'use strict';

const Hapi = require('@hapi/hapi');

const server = Hapi.server({
    port: 3000,
    host: '0.0.0.0'
});

server.route({
    method: 'GET',
    path: '/',
    handler: (request, h) => {
      try {
        return request.headers['x-forwarded-for'];
      }catch(e) {
        return request.info.remoteAddress;
      }
    }
});

server.route({
  method: 'GET',
  path: '/health',
  handler: (request, h) => {
    return 'OK'
  }
})

const init = async () => {

    await server.start();
    console.log(`Server running at: ${server.info.uri}`);
};

process.on('unhandledRejection', (err) => {
    console.log(err);
    process.exit(1);
});

const stopServer = () => {
  console.log('stopping hapi server')

  server.stop({ timeout: 30000 }).then(function (err) {
    console.log('hapi server stopped')
    process.exit((err) ? 1 : 0)
  })
}
// listen on SIGINT signal and gracefully stop the server
process.on('SIGINT', stopServer)
process.on('SIGTERM', stopServer)

init();
