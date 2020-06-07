-- pong-8 / junkdeck

-- constants
p_speed = 5
p_accel = 1
p_deccel = 1
deadzone = 1

function _init()
  pw=4      -- paddle width
  ph=16     -- paddle height
  bd=2      -- ball diameter

  -- spawning coords for ball
  bspw={x=63, y=20}

  p1={
    w=pw,
    h=ph,
    id=0,
    x=0,
    y=64,
    sc=0,
    _v={x=0, y=0}
  }
  p2={
    w=pw,
    h=ph,
    id=1,
    x=123,
    y=64,
    sc=0,
    _v={x=0, y=0}
  }

  b={
    w=bd,
    h=bd,
    x=bspw.x,
    y=bspw.y,
    _v={x=1, y=1}
  }
end

function spawnball()
  b.x = bspw.x
  b.y = bspw.y

  local dir

  if (rnd() > 0.5) then
    dir = 1
  else
    dir = -1
  end

  b._v.x = dir
  b._v.y = 1
end

function stopplayer(p, y)
  p._v.y = 0
  p.y = y
end

function playerdeccel(p)

  if(p._v.y < deadzone and p._v.y > -deadzone) then
    p._v.y = 0
  else
    p._v.y -= p_deccel*sgn(p._v.y)
  end
end

function playermove(p)
  -- move player by applying
  -- acceleration to velocity

  if(btn(⬆️, p.id)) then
    p._v.y -= p_accel
  elseif(btn(⬇️, p.id)) then
    p._v.y += p_accel
  else
    playerdeccel(p)
  end

  -- limit player speed
  if(abs(p._v.y) > p_speed) then
    p._v.y = sgn(p._v.y) * p_speed
  end

  -- player movement
  p.y += p._v.y

end

function playerbounds(p)
  if(p.y > 127-ph) stopplayer(p, 127-ph)
  if(p.y < 0) stopplayer(p, 0)
end

function collide(a, b)
  local x1, y1, w1, h1 = a.x, a.y, a.w, a.h
  local x2, y2, w2, h2 = b.x, b.y, b.w, b.h

  local xd = abs((x1 + (w1/2)) - (x2 + (w2/2)))
  local xs = (w1/2) + (w2/2)

  local yd = abs((y1 + (h1/2)) - (y2 + (h2/2)))
  local ys = (h1/2) + (h2/2)

  if(xd < xs and yd < ys) then
    sfx(0)
    return true
  else
    return false
  end
end

function drawscore(p, x)
  numtable = {
    [0] = 10,
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5,
    [6] = 6,
    [7] = 7,
    [8] = 8,
    [9] = 9,
  }

  score = tostr(p.sc)

  for n=1,#score do
    c=sub(score, n, n)

    spr(numtable[tonum(c)], 
    x-(#score/2)*8+(n*8), 0)
  end

end



function _update()
  -- player 1 controls
  playermove(p1)

  -- player 2 controls
  playermove(p2)

  -- player bounds
  playerbounds(p1)
  playerbounds(p2)



  -- ball boundary
  if(b.y > 128-bd or b.y < 0) then 
    sfx(1)
    b._v.y *= -1 
  end

  -- scoring
  if(b.x > 128) p1.sc += 1
  if(b.x < -bd) p2.sc +=1
  if(b.x > 128 or b.x < -bd) spawnball()

  -- ball movement
  b.x += b._v.x * 2
  b.y += b._v.y * 1

  -- ball collision detection
  if(collide(p1, b) or
    collide(p2, b)) then
    b._v.x *= -1	
  end
end

function _draw()
  cls()

  -- score
  drawscore(p1, 44)
  drawscore(p2, 68)

  -- player 1
  rectfill(p1.x, p1.y, 
  p1.x+pw, p1.y+ph)
  -- player 2
  rectfill(p2.x, p2.y,
  p2.x+pw, p2.y+ph)					
  -- ball
  rectfill(b.x, b.y,
  b.x+bd, b.y+bd)
  -- divider
  rectfill(63,0,65,128, 7)
end
