<template>
  <div>
    <div id="nav">
      <a href="/home">Home</a> |
      <span v-if="isLoggedIn">
        <a @click="logout">Logout</a>
      </span>
      <span v-else>
        <a href="/signup">Register</a> |
        <a href="/login">Login</a>
      </span>
    </div>
  </div>
</template>

<script>
import request from "../api/request";
export default {
  name: "navbar",
  props: {
    isLoggedIn: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    async logout() {
      await request("/api/logout", {}, "delete");
      sessionStorage.removeItem("user_id");
      window.location.href = "/login";
    }
  }
};
</script>
