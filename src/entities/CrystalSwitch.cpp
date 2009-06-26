/*
 * Copyright (C) 2009 Christopho, Zelda Solarus - http://www.zelda-solarus.com
 * 
 * Zelda: Mystery of Solarus DX is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Zelda: Mystery of Solarus DX is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */
#include "entities/CrystalSwitch.h"
#include "entities/CarriedItem.h"
#include "entities/Boomerang.h"
#include "entities/Hero.h"
#include "ZSDX.h"
#include "Game.h"
#include "Sprite.h"
#include "SpriteAnimationSet.h"
#include "ResourceManager.h"
#include "Sound.h"
#include "KeysEffect.h"
using std::string;

/**
 * Creates a new crystal switch.
 * @param layer layer of the entity to create on the map
 * @param x x coordinate of the entity to create
 * @param y y coordinate of the entity to create
 */
CrystalSwitch::CrystalSwitch(Layer layer, int x, int y):
  Detector(COLLISION_SPRITE | COLLISION_RECTANGLE | COLLISION_FACING_POINT,
	   "", layer, x, y, 16, 16),
  state(false), next_possible_hit_date(SDL_GetTicks()) {

  set_origin(8, 13);
  create_sprite("entities/crystal_switch");
  get_sprite()->get_animation_set()->enable_pixel_collisions();
}

/**
 * Destructor.
 */
CrystalSwitch::~CrystalSwitch(void) {

}

/**
 * Returns the type of entity.
 * @return the type of entity
 */
EntityType CrystalSwitch::get_type() {
  return CRYSTAL_SWITCH;
}

/**
 * Returns whether this entity is an obstacle for another one.
 * @param other another entity
 * @return true
 */
bool CrystalSwitch::is_obstacle_for(MapEntity *other) {

  if (other->get_type() != CARRIED_ITEM && other->get_type() != BOOMERANG) {
    return true;
  }

  CarriedItem *item = (CarriedItem*) other;
  return !item->is_being_thrown();
}

/**
 * This function is called when another entity collides with this crystal switch.
 * @param entity_overlapping the other entity
 * @param collision_mode the collision mode that detected the collision
 */
void CrystalSwitch::collision(MapEntity *entity_overlapping, CollisionMode collision_mode) {

  if (entity_overlapping->get_type() == CARRIED_ITEM && collision_mode == COLLISION_RECTANGLE) {

    CarriedItem *item = (CarriedItem*) entity_overlapping;
    if (item->is_being_thrown()) {
      activate();
      item->break_item();
    }
  }
  else if (entity_overlapping->get_type() == BOOMERANG && collision_mode == COLLISION_RECTANGLE) {

    Boomerang *boomerang = (Boomerang*) boomerang;
    activate();
    if (!boomerang->is_going_back()) {
      boomerang->go_back();
    }
  }
  else if (entity_overlapping->is_hero() && collision_mode == COLLISION_FACING_POINT) {

    Hero *hero = (Hero*) entity_overlapping;
    KeysEffect *keys_effect = zsdx->game->get_keys_effect();

    if (keys_effect->get_action_key_effect() == KeysEffect::ACTION_KEY_NONE
	&& hero->get_state() == Hero::FREE) {

      // we show the action icon
      keys_effect->set_action_key_effect(KeysEffect::ACTION_KEY_LOOK);
    }
  }
}

/**
 * This function is called by the engine when a sprite overlaps the crystal switch.
 * If the entity is the hero, we allow him to lift the item.
 * @param entity an entity
 * @param sprite_overlapping the sprite of this entity that is overlapping the detector
 */
void CrystalSwitch::collision(MapEntity *entity, Sprite *sprite_overlapping) {

  if (entity->is_hero() &&
      sprite_overlapping->get_animation_set_id().find("sword") != string::npos) {
    // the hero's sword is overlapping the crystal switch

    Hero *hero = (Hero*) entity;
    if (hero->get_state() != Hero::SWORD_LOADING && get_distance(hero) < 32) {
      activate();
    }
  }
}

/**
 * This function is called when the player presses the action key
 * when the hero is facing this detector, and the action icon lets him do this.
 */
void CrystalSwitch::action_key_pressed(void) {

  KeysEffect *keys_effect = zsdx->game->get_keys_effect();
  Hero *hero = zsdx->game->get_hero();

  if (hero->get_state() == Hero::FREE) {
    keys_effect->set_action_key_effect(KeysEffect::ACTION_KEY_NONE);

    // start a dialog
    zsdx->game->show_message("_crystal_switch");
  }
}

/**
 * Activates the crystal switch if the delay since the last activation allows it.
 */
void CrystalSwitch::activate(void) {

  Uint32 now = SDL_GetTicks();
  if (now >= next_possible_hit_date) {
    ResourceManager::get_sound("switch")->play();
    zsdx->game->change_crystal_switch_state();
    next_possible_hit_date = now + 500;
  }
}

/**
 * Updates the entity.
 */
void CrystalSwitch::update(void) {

  bool state = zsdx->game->get_crystal_switch_state();
  if (state != this->state) {

    this->state = state;
    get_sprite()->set_current_animation(state ? "blue_lowered" : "orange_lowered");
  }
  MapEntity::update();
}

/**
 * Suspends or resumes the entity.
 * @param suspended true to suspend the entity, false to resume it
 */
void CrystalSwitch::set_suspended(bool suspended) {

  MapEntity::set_suspended(suspended);

  if (!suspended) {
    next_possible_hit_date += SDL_GetTicks() - when_suspended;
  }
}
