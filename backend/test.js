const axios = require("axios");
const fs = require("fs");









axios
  .post("http://uhmusic.xyz/api/validateUser", {
    username: "User1",
    password: "Password123"
  })
  .then(function (response) {
    console.log(response.data);
  });
