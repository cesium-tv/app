import Vue from 'vue';
import Router from 'vue-router';
import Home from '@/views/Home';
import Subscriptions from '@/views/Subscriptions';
import Search from '@/views/Search';
import Settings from '@/views/Settings';
import Login from '@/views/Login';
import store from './store';

Vue.use(Router)

const router = new Router({
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home,
    },
    {
      path: '/subscriptions',
      name: 'subscriptions',
      component: Subscriptions,
    },
    {
      path: '/search',
      name: 'search',
      component: Search,
    },
    {
      path: '/settings',
      name: 'settings',
      component: Settings,
    },
    {
      path: '/login',
      name: 'login',
      component: Login,
    },
  ]
});

router.beforeEach((to, from, next) => {
  if (!store.isAuthenticated && to.path !== '/login') {
    next('/login');
    return;
  }
  next();
});

export default router;
