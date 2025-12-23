import './bootstrap';
import 'bootstrap/dist/css/bootstrap.min.css';  // Bootstrap CSS
import 'bootstrap'
import { createApp } from 'vue';
import router from './router';
import App from './App.vue';

const app = createApp(App);
app.use(router);
app.mount('#app');