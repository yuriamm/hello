<template>
  <div>
    <NavBar :isLoggedIn="isLoggedIn" />
    <div v-if="isLoggedIn">
      <div class="alert alert-danger" v-if="error">Error!</div>
      <div class="alert alert-success" v-if="success">Success!</div>
      <form @submit.prevent="tweet">
        <input v-model="post" type="text" required />

        <button type="submit">Tweet</button>
      </form>
    </div>
    <div v-for="tweet in tweets" :key="tweet.id">
      <span>{{ tweet.tweet }}</span>
      <div v-if="isLoggedIn">
        <button
          v-if="tweet.user_id === parseInt(user_id)"
          @click="remove(tweet.id)"
        >
          Delete
        </button>
        <button v-if="isFavorited(tweet)" @click="unfavorite(tweet.id)">
          Unfavorite
        </button>
        <button v-else @click="favorite(tweet.id)">
          Favorite
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import request from "../api/request";
import NavBar from "./NavBar";
export default {
  name: "tweet",
  components: {
    NavBar
  },
  data() {
    return {
      tweets: [],
      post: "",
      user_id: 0,
      error: false,
      success: false,
      isLoggedIn: false
    };
  },
  async created() {
    const user_id = sessionStorage.getItem("user_id");
    if (user_id) {
      this.isLoggedIn = true;
      this.user_id = user_id;
    }
  },
  async mounted() {
    const response = await request("/api/home", {}, "get");
    this.tweets = response.data.tweets;
  },
  methods: {
    isFavorited(tweet) {
      return tweet.users_favorited.includes(parseInt(this.user_id));
    },
    async tweet() {
      const response = await request("/api/home", { tweet: this.post }, "post");
      if (response.data.message === "success") {
        this.tweets = [response.data, ...this.tweets];
        window.location.href = "/home";
        this.success = true;
      }
      if (response.data.message === "error") {
        this.error = true;
      }
    },
    async remove(id) {
      const response = await request(`/api/home/${id}`, {}, "delete");
      if (response.data.message === "success") {
        window.location.href = "/home";
        this.success = true;
      }
      if (response.data.message === "error") {
        this.error = true;
      }
    },
    async favorite(id) {
      const response = await request(`/api/favorite`, { id: id }, "post");
      if (response.data.message === "success") {
        window.location.href = "/home";
        this.success = true;
      }
      if (response.data.message === "error") {
        this.error = true;
      }
    },
    async unfavorite(id) {
      const response = await request(`/api/favorite/${id}`, {}, "delete");
      if (response.data.message === "success") {
        window.location.href = "/home";
        this.success = true;
      }
      if (response.data.message === "error") {
        this.error = true;
      }
    }
  }
};
</script>
