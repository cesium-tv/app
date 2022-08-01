<template>
  <section>
    <b-sidebar
      type="is-dark"
      :fullheight="true"
      :fullwidth="false"
      :overlay="false"
      :right="false"
      :reduce="reduce"
      :open="true"
      :can-cancel="false"
    >
      <div class="p-1">
        <div class="logo">
          <img
            id="logo"
            :src="icon"
            alt="Video player"
          />
        </div>
        <b-menu>
          <div
            @errokees:selected="onMenuSelected"
            @errokees:deselected="onMenuDeselected"
            data-ek-activate-event-name="click"
            data-ek-activate-event-target="a"
            class="errokees-selectable"
          >
            <b-menu-list>
              <b-menu-item
                icon="login"
                label="Login"
                tag="router-link"
                to="/login"
              ></b-menu-item>
            </b-menu-list>
          </div>
          <div
            @errokees:selected="onMenuSelected"
            @errokees:deselected="onMenuDeselected"
            data-ek-activate-event-name="click"
            data-ek-activate-event-target="a"
            class="errokees-selectable"
          >
            <b-menu-list>
              <b-menu-item
                icon="home"
                label="Home"
                tag="router-link"
                to="/"
              ></b-menu-item>
            </b-menu-list>
          </div>
          <div
            @errokees:selected="onMenuSelected"
            @errokees:deselected="onMenuDeselected"
            data-ek-activate-event-name="click"
            data-ek-activate-event-target="a"
            class="errokees-selectable"
          >
            <b-menu-list>
              <b-menu-item
                icon="magnify"
                label="Search"
                tag="router-link"
                to="/search"
              ></b-menu-item>
            </b-menu-list>
          </div>
          <div
            @errokees:selected="onMenuSelected"
            @errokees:deselected="onMenuDeselected"
            data-ek-activate-event-name="click"
            data-ek-activate-event-target="a"
            class="errokees-selectable"
          >
            <b-menu-list>
              <b-menu-item
                icon="cog-outline"
                label="Settings"
                tag="router-link"
                to="/settings"
              ></b-menu-item>
            </b-menu-list>
          </div>
          <div
            @errokees:selected="onMenuSelected"
            @errokees:deselected="onMenuDeselected"
            data-ek-activate-event-name="click"
            data-ek-activate-event-target="a"
            class="errokees-selectable"
          >
            <b-menu-list>
              <b-menu-item
                icon="key-outline"
                label="Accounts"
                tag="router-link"
                to="/subscriptions"
              ></b-menu-item>
            </b-menu-list>
          </div>
        </b-menu>
      </div>
    </b-sidebar>
  </section>
</template>

<script>
import icon from '@/assets/icon.png';

export default {
  name: 'Sidebar',

  data() {
    return {
      icon,
      reduce: true,
    };
  },

  methods: {
    onMenuSelected() {
      this.reduce = false;
    },

    onMenuDeselected() {
      this.reduce = true;
    }
  },
};
</script>

<style lang="scss">
.errokees-selected ul li a {
  background-color: hsl(204, 86%, 53%);
  color: hsl(0, 0%, 100%);
}

.logo {
  text-align: center;
  padding-top: 5px;
}

.menu-list li {
  height: 40px;
}

.menu {
  position: absolute;
  top: 110px;
}

.p-1 {
  padding: 1em;
}

.b-sidebar {
    .sidebar-content {
      width: 132px;
        &.is-mini {
          width: 48px;
            &:not(.is-mini-expand),
            &.is-mini-expand:not(.is-mini-delayed) {
                .menu-list {
                    li {
                        a {
                            span:nth-child(2) {
                                display: none;
                            }
                        }
                    }
                }
            }
        }
    }
}
</style>