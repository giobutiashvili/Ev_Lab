import { createRouter, createWebHistory } from 'vue-router';
import ExampleComponent from '../components/ExampleComponent.vue';

const routes = [

    {
        path: '/',
        name: 'ExampleComponent',
        component: ExampleComponent,
    },
]




export const router = createRouter({ 
     history: createWebHistory(),
     routes,
});

export default router;
    