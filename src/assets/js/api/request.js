import axios from "axios";

export default async function request(url, data, method) {
  try {
    let response;
    if (method === "delete") {
      response = await axios({
        method: method,
        url: url,
        data: data,
      });
    } else {
      response = await axios({
        method: method,
        url: url,
        data: data,
        headers: {
          "x-csrf-token": document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute("content"),
        },
      });
    }

    return response;
  } catch (error) {
    console.error(error.message);
  }
}
