<template>
  <div>
    <NavBar :isLoggedIn="isLoggedIn" />
    <div v-if="isLoggedIn">You're Logged In!</div>
    <div v-else>
      <h1>Register</h1>
      <div class="alert alert-danger" v-if="error">Error!</div>
      <form class="register" @submit.prevent="register">
        <input
          v-model="user.username"
          placeholder="username"
          type="text"
          required
        />
        <input
          v-model="user.password"
          placeholder="password"
          type="password"
          required
        />
        <input
          v-model="user.password_confirmation"
          placeholder="password confirmation"
          type="password"
          required
        />

        <button type="submit">Submit</button>
      </form>
    </div>
  </div>
</template>

<script>
import request from "../api/request.js";
import NavBar from "./NavBar";
export default {
  name: "registration",
  components: {
    NavBar
  },
  data() {
    return {
      user: {
        username: "",
        password: "",
        password_confirmation: ""
      },
      error: false,
      isLoggedIn: false
    };
  },
  methods: {
    async register() {
      const response = await request("/api/signup", this.user, "post");
      if (response.data.message === "success") {
        sessionStorage.setItem("user_id", response.data.user);
        this.isLoggedIn = true;
        window.location.href = "/home";
      }
      if (response.data.message === "error") {
        this.error = true;
      }
    }
  }
};
</script>
