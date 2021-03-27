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
    <div v-for="(tweet, index) in tweets" :key="index">
      <span>{{ tweet.tweet }}</span>
      <div v-if="isLoggedIn">
        <button v-if="tweet.user_id === user_id" @click="remove(tweet.id)">
          Delete
        </button>
        <button
          v-if="tweet.users_favorited.includes(user_id)"
          @click="unfavorite(tweet.id, index)"
        >
          Unfavorite
        </button>
        <button v-else @click="favorite(tweet.id, index)">
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
      tweets: [
        {
          tweet: "",
          id: 0,
          user_id: 0,
          users_favorited: []
        }
      ],
      post: "",
      user_id: 0,
      error: false,
      success: false,
      isLoggedIn: false
    };
  },
  async created() {
    const user_id = JSON.parse(sessionStorage.getItem("user_id"));
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
    async tweet() {
      const response = await request("/api/home", { tweet: this.post }, "post");
      if (response.data.message === "tweeted") {
        this.tweets = [response.data, ...this.tweets];
        this.post = "";
        this.success = true;
      }
      if (response.data.message === "error") {
        this.error = true;
      }
    },
    async remove(id) {
      const response = await request(`/api/home/${id}`, {}, "delete");
      if (response.data.message === "deleted") {
        this.tweets = this.tweets.filter(tweet => tweet.id !== id);
        this.success = true;
      }
      if (response.data.message === "error") {
        this.error = true;
      }
    },
    async favorite(id, index) {
      const response = await request(`/api/favorite`, { id: id }, "post");
      if (response.data.message === "favorited") {
        this.tweets[index].users_favorited.push(this.user_id);
        this.success = true;
      }
      if (response.data.message === "error") {
        this.error = true;
      }
    },
    async unfavorite(id, index) {
      const response = await request(`/api/favorite/${id}`, {}, "delete");
      if (response.data.message === "success") {
        this.tweets[index].users_favorited = this.tweets[
          index
        ].users_favorited.filter(user_id => user_id !== this.user_id);
        this.success = true;
      }
      if (response.data.message === "error") {
        this.error = true;
      }
    }
  }
};
</script>
