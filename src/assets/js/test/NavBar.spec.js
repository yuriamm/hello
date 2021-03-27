import { shallowMount } from "@vue/test-utils";
import NavBar from "../components/NavBar.vue";

global.window = Object.create(window);
const url = "http://localhost:4000";
Object.defineProperty(window, "location", {
  value: {
    href: url,
  },
});

const wrapper = shallowMount(NavBar);

describe("NavBar.vue", () => {
  it("snapshot macthes", async () => {
    expect(wrapper.element).toMatchSnapshot();
  });

  it("snapshot macthes when logged in", async () => {
    await wrapper.setProps({ isLoggedIn: true });

    expect(wrapper.element).toMatchSnapshot();
  });

  it("to have href attribute of home", async () => {
    await wrapper.setProps({ isLoggedIn: false });
    const link = wrapper.findAll("a").at(0);

    expect(link.attributes("href")).toBe("/home");
  });

  it("to have href attribute of register", async () => {
    await wrapper.setProps({ isLoggedIn: false });
    const link = wrapper.findAll("a").at(1);

    expect(link.attributes("href")).toBe("/signup");
  });

  it("to have href attribute of login", async () => {
    await wrapper.setProps({ isLoggedIn: false });
    const link = wrapper.findAll("a").at(2);

    expect(link.attributes("href")).toBe("/login");
  });

  it("to have href attribute of logout when is logged in", async () => {
    await wrapper.setProps({ isLoggedIn: true });
    const link = wrapper.findAll("a").at(1);
    await link.trigger("click");

    expect(window.location.href).toEqual("/login");
  });
});
