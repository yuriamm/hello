import { shallowMount } from "@vue/test-utils";
import Registration from "../components/Registration.vue";
jest.mock("../api/request.js");

global.window = Object.create(window);
const url = "http://localhost:4000";
Object.defineProperty(window, "location", {
  value: {
    href: url,
  },
});

const wrapper = shallowMount(Registration);

describe("Session.vue", () => {
  it("snapshot matches", async () => {
    expect(wrapper.element).toMatchSnapshot();
  });

  it("snapshot matches when logged in", async () => {
    await wrapper.setData({ isLoggedIn: true });

    expect(wrapper.element).toMatchSnapshot();
  });

  it("redirects to correct path", async () => {
    await wrapper.setData({
      isLoggedIn: false,
      user: {
        username: "username",
        password: "password",
        password_confirmation: "password",
      },
    });
    wrapper.find("form").trigger("submit.prevent");
    await wrapper.vm.$nextTick();
    expect(window.location.href).toEqual("/home");
  });

  it("raises error when username is empty", async () => {
    await wrapper.setData({
      isLoggedIn: false,
      user: {
        username: "",
        password: "password",
        password_confirmation: "password",
      },
    });
    wrapper.find("form").trigger("submit.prevent");
    await wrapper.vm.$nextTick();
    expect(wrapper.vm.error).toBeTruthy();
  });
});
