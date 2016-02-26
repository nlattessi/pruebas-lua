function love.load()
  bg = love.graphics.newImage("bg.png")
  hero = {} -- new table for the hero
  hero.x = 300 -- x,y coordinates of the hero
  hero.y = 450
  hero.width = 30
  hero.height = 15
  hero.speed = 150
  hero.shoots = {} -- holds our fired shoots
  enemies = {}
  for i=0,7 do
    enemy = {}
    enemy.width = 40
    enemy.height = 20
    enemy.x = i * (enemy.width + 60) + 100
    enemy.y = enemy.height + 100
    table.insert(enemies, enemy)
  end
end

function love.keyreleased(key)
    if (key == "up") then
        shoot()
    end
end

function love.update(dt)
  if love.keyboard.isDown("left") then
    hero.x = hero.x - hero.speed*dt
  elseif love.keyboard.isDown("right") then
    hero.x = hero.x + hero.speed*dt
  end

  local remEnemy = {}
  local remShot = {}

  -- update those shoots
  for i,v in ipairs(hero.shoots) do
    -- move them up up up
    v.y = v.y - dt * 100
    -- mark shoots that are not visible for removal
    if v.y < 0 then
      table.insert(remShot, i)
    end
    -- check for collision whit enemies
    for ii, vv in ipairs(enemies) do
      if CheckCollision(v.x, v.y, 2, 5, vv.x, vv.y, vv.width, vv.height) then
        -- mark that enemy for removal
        table.insert(remEnemy, ii)
        -- mark that shoot to be removed
        table.insert(remShot, i)
      end
    end
  end

  -- remove marked enemies
  for i,v in ipairs(remEnemy) do
    table.remove(enemies, v)
  end

  for i,v in ipairs(remShot) do
    table.remove(hero.shoots, v)
  end

  for i,v in ipairs(enemies) do
    -- let them fall down slowly
    v.y = v.y + dt

    -- check for collision with ground
    if v.y < 465 then
      -- you lose
    end
  end
end

function love.draw()
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(bg)

  -- let's draw some ground
  love.graphics.setColor(0,255,0,255)
  love.graphics.rectangle("fill", 0, 465, 800, 150)

  -- let's draw our hero
  love.graphics.setColor(255,255, 0, 255)
  love.graphics.rectangle("fill", hero.x,hero.y, 30, 15)

  love.graphics.setColor(255,255,255,255)
  for i,v in ipairs(hero.shoots) do
    love.graphics.rectangle("fill", v.x, v.y, 2, 5)
  end

  love.graphics.setColor(0,255,255,255)
  for i,v in ipairs(enemies) do
    love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
  end
end

function shoot()
  local shot = {}
  shot.x = hero.x + hero.width / 2
  shot.y = hero.y
  table.insert(hero.shoots, shot)
end

-- Collision detection function.
-- Returns true if two boxes overlap, false if they don't
-- x1,y1 are the left-top coords of the first box, while w1,h1 are its width and height
-- x2,y2,w2 & h2 are the same, but for the second box
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
