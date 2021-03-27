import { shallowMount } from "@vue/test-utils";
import Tweet from "../components/Tweet.vue";
jest.mock("../api/request.js");

global.window = Object.create(window);
const url = "http://localhost:4000";
Object.defineProperty(window, "location", {
  value: {
    href: url,
  },
});

const wrapper = shallowMount(Tweet);

describe("Tweet.vue", () => {
  it("renders correctly", () => {
    expect(wrapper.element).toMatchSnapshot();
  });

  it("renders correctly when logged in", async () => {
    await wrapper.setData({
      isLoggedIn: true,
    });

    expect(wrapper.element).toMatchSnapshot();
  });

  it("redirects to correct path when tweet", async () => {
    await wrapper.setData({
      post: "post",
      isLoggedIn: true,
    });
    const button = wrapper.findAll("button").at(0);
    expect(button.text()).toEqual("Tweet");

    wrapper.find("form").trigger("submit.prevent");
    wrapper.vm.$nextTick(() => {
      expect(window.location.href).toEqual("/home");
      done();
    });
  });

  it("redirects to correct path when delete", async () => {
    await wrapper.setData({
      tweets: [
        {
          tweet: "tweet",
          id: 1,
          user_id: 0,
          users_favorited: [],
        },
      ],
      user_id: "0",
      isLoggedIn: true,
    });
    const button = wrapper.findAll("button").at(1);
    expect(button.text()).toEqual("Delete");

    button.trigger("click");
    wrapper.vm.$nextTick(() => {
      expect(window.location.href).toEqual("/home");
      done();
    });
  });

  it("redirects to correct path when unfavorite", async () => {
    await wrapper.setData({
      tweets: [
        {
          tweet: "tweet",
          id: 1,
          user_id: 1,
          users_favorited: [0],
        },
      ],
      user_id: "0",
      isLoggedIn: true,
    });
    const button = wrapper.findAll("button").at(1);
    expect(button.text()).toEqual("Unfavorite");

    button.trigger("click");
    wrapper.vm.$nextTick(() => {
      expect(window.location.href).toEqual("/home");
      done();
    });
  });

  it("redirects to correct path when favorite", async () => {
    await wrapper.setData({
      tweets: [
        {
          tweet: "tweet",
          id: 1,
          user_id: 1,
          users_favorited: [1],
        },
      ],
      user_id: "0",
      isLoggedIn: true,
    });
    const button = wrapper.findAll("button").at(1);
    expect(button.text()).toEqual("Favorite");

    button.trigger("click");
    wrapper.vm.$nextTick(() => {
      expect(window.location.href).toEqual("/home");
      done();
    });
  });
});
