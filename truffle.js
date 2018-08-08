module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    production: {
      host: "fbcpag5uo.southeastasia.cloudapp.azure.com",
      port: 8545,
      network_id: "10101010" 
    }
  }
};
