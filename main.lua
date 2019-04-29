display.setDefault ( "background", 53/255, 235/255, 242/255)



local physics = require( "physics" )



local playerBullets = {}



physics.start()

physics.setGravity( 0, 25 ) -- ( x, y )

physics.setDrawMode( "hybrid" )   -- Shows collision engine outlines only



local leftWall = display.newRect( 0, display.contentHeight / 2, 1, display.contentHeight )

-- myRectangle.strokeWidth = 3

-- myRectangle:setFillColor( 0.5 )

-- myRectangle:setStrokeColor( 1, 0, 0 )

leftWall.alpha = 0.0

physics.addBody( leftWall, "static", { 

    friction = 0.5, 

    bounce = 0.3 

    } )



local rightWall = display.newRect( 320, display.contentHeight / 2, 1, display.contentHeight )

-- myRectangle.strokeWidth = 3

-- myRectangle:setFillColor( 0.5 )

-- myRectangle:setStrokeColor( 1, 0, 0 )

rightWall.alpha = 0.0

physics.addBody( rightWall, "static", { 

    friction = 0.5, 

    bounce = 0.3 

    } )



local theGround = display.newImage( "assets/images/land.png" )

theGround.x = display.contentCenterX

theGround.y = display.contentHeight

theGround.id = "the ground"

physics.addBody( theGround, "static", { 

    friction = 0.5, 

    bounce = 0.3 

    } )



local shoot = display.newImageRect( "assets/images/shoot.png", 50, 50 )

shoot.x = 275

shoot.y = 475

shoot.id = "shoot button"



local dPad = display.newImageRect( "assets/images/d-pad.png", 200, 200 )

dPad.x = 160

dPad.y = display.contentHeight - 75

dPad.id = "d-pad"



local upArrow = display.newImageRect( "assets/images/upArrow.png", 50, 30)

upArrow.x = 160

upArrow.y = display.contentHeight - 148

upArrow.id = "up arrow"



local downArrow = display.newImageRect( "assets/images/downArrow.png", 50, 30)

downArrow.x = 160

downArrow.y = display.contentHeight - 2

downArrow.id = "down arrow"



local rightArrow = display.newImageRect( "assets/images/rightArrow.png", 30, 50)

rightArrow.x = 233

rightArrow.y = display.contentHeight - 75

rightArrow.id = "right arrow"



local leftArrow = display.newImageRect( "assets/images/leftArrow.png", 30, 50)

leftArrow.x = 87

leftArrow.y = display.contentHeight - 75

leftArrow.id = "right arrow"



local jumpButton = display.newImageRect( "assets/images/jumpButton.png", 65, 65 )

jumpButton.x = 160

jumpButton.y = 400

jumpButton.id = "jump button"



local theCharacter = display.newImageRect( "assets/images/character.png", 150, 150 )

theCharacter.x = display.contentCenterX

theCharacter.y = display.contentCenterY

theCharacter.id = "the character"

physics.addBody( theCharacter, "dynamic", { 

    density = 3.0, 

    friction = 0.5, 

    bounce = 0.3 

    } )



local character2 = display.newImageRect( "assets/images/character2.png", 200, 200 )

character2.x = 160

character2.y = 100

character2.id = "bad character"

physics.addBody( character2, "dynamic", { 

    friction = 0.5, 

    bounce = 0.3 

    } )

 

function checkCharacterPosition( event )

    -- check every frame to see if character has fallen

    if theCharacter.y > display.contentHeight + 500 then

        theCharacter.x = 160

        theCharacter.y = 240

    end

end



function upArrow:touch( event )

    if ( event.phase == "ended" ) then

        -- move the character up

        transition.moveBy( theCharacter, { 

            x = 0, -- move 0 in the x direction 

            y = -50, -- move up 50 pixels

            time = 100 -- move in a 1/10 of a second

            } )

    end



    return true

end



function downArrow:touch( event )

    if ( event.phase == "ended" ) then

        -- move the character down

        transition.moveBy( theCharacter, { 

            x = 0, -- move 0 in the x direction 

            y = 50, -- move down 50 pixels

            time = 100 -- move in a 1/10 of a second

            } )

    end



    return true

end



function rightArrow:touch( event )

    if ( event.phase == "ended" ) then

        -- move the character right

        transition.moveBy( theCharacter, { 

            x = 50, -- move right 50 pixels 

            y = 0, -- move 0 pixels in the y direction

            time = 100 -- move in a 1/10 of a second

            } )
    
    end



    return true

end



function leftArrow:touch( event )

    if ( event.phase == "ended" ) then

        -- move the character left

        transition.moveBy( theCharacter, { 

            x = -50, -- move left 50 pixels 

            y = 0, -- move 0 in the y direction

            time = 100 -- move in a 1/10 of a second

            } )

    end



    return true

end



function jumpButton:touch( event )

    if ( event.phase == "ended" ) then

        -- make the character jump

        theCharacter:setLinearVelocity( 0, -750 )

    end



    return true

end



function shoot:touch( event )

    if ( event.phase == "began" ) then

        -- make a bullet appear

        local aSingleBullet = display.newImageRect( "assets/images/bullet.png", 25, 50 )

        aSingleBullet.x = theCharacter.x

        aSingleBullet.y = theCharacter.y

        physics.addBody( aSingleBullet, 'dynamic' )

        -- Make the object a "bullet" type object

        aSingleBullet.isBullet = true

        aSingleBullet.isFixedRotation = true

        aSingleBullet.gravityScale = 0

        aSingleBullet.id = "bullet"

        aSingleBullet:setLinearVelocity( 0, 1500 )



        table.insert(playerBullets,aSingleBullet)

        print("# of bullet: " .. tostring(#playerBullets))

    end



    return true

end



local function checkPlayerBulletsOutOfBounds()

    -- check if any bullets have gone off the screen

    local bulletCounter



    if #playerBullets > 0 then

        for bulletCounter = #playerBullets, 1 , -1 do

            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then

                playerBullets[bulletCounter]:removeSelf()

                playerBullets[bulletCounter] = nil

                table.remove(playerBullets, bulletCounter)

                print("remove bullet")

            end

        end

    end

end



local function onCollision( event )

 

    if ( event.phase == "began" ) then

 

        local obj1 = event.object1

        local obj2 = event.object2

        local whereCollisonOccurredX = obj1.x

        local whereCollisonOccurredY = obj1.y



        if ( ( obj1.id == "bad character" and obj2.id == "bullet" ) or

             ( obj1.id == "bullet" and obj2.id == "bad character" ) ) then

            -- Remove both the laser and asteroid

            display.remove( obj1 )

            display.remove( obj2 )

 			

 			-- remove the bullet

 			local bulletCounter = nil

 			

            for bulletCounter = #playerBullets, 1, -1 do

                if ( playerBullets[bulletCounter] == obj1 or playerBullets[bulletCounter] == obj2 ) then

                    playerBullets[bulletCounter]:removeSelf()

                    playerBullets[bulletCounter] = nil

                    table.remove( playerBullets, bulletCounter )

                    break

                end

            end



            --remove character

            character2:removeSelf()

            character2 = nil



            -- Increase score

            score = 1

            print ("Eliminations:", score)



            -- make an explosion sound effect

            local expolsionSound = audio.loadStream( "Assets/explosion.wav" )

            local explosionChannel = audio.play( expolsionSound )



            -- make an explosion happen



            -- Table of emitter parameters

			local emitterParams = {

			    startColorAlpha = 1,

			    startParticleSizeVariance = 250,

			    startColorGreen = 0.3031555,

			    yCoordFlipped = -1,

			    blendFuncSource = 770,

			    rotatePerSecondVariance = 153.95,

			    particleLifespan = 0.7237,

			    tangentialAcceleration = -1440.74,

			    finishColorBlue = 0.3699196,

			    finishColorGreen = 0.5443883,

			    blendFuncDestination = 1,

			    startParticleSize = 50,

			    startColorRed = 0.8373094,

			    textureFileName = "Assets/fire.png",

			    startColorVarianceAlpha = 1,

			    maxParticles = 256,

			    finishParticleSize = 50,

			    duration = 0.25,

			    finishColorRed = 1,

			    maxRadiusVariance = 72.63,

			    finishParticleSizeVariance = 50,

			    gravityy = -671.05,

			    speedVariance = 90.79,

			    tangentialAccelVariance = -420.11,

			    angleVariance = -142.62,

			    angle = -244.11

			}



			local emitter = display.newEmitter( emitterParams )

			emitter.x = whereCollisonOccurredX

			emitter.y = whereCollisonOccurredY



        end

    end

end







upArrow:addEventListener( "touch", upArrow )



downArrow:addEventListener( "touch", downArrow )



rightArrow:addEventListener( "touch", rightArrow)



leftArrow:addEventListener( "touch", leftArrow)



jumpButton:addEventListener( "touch", jumpButton )



shoot:addEventListener( "touch", shootTouch )



Runtime:addEventListener( "collision", onCollision )



Runtime:addEventListener( "enterFrame", checkPlayerBulletsOutOfBounds )



Runtime:addEventListener( "enterFrame", checkCharacterPosition )