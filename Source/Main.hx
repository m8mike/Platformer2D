import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2DebugDraw;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.B2World;
import openfl.display.Sprite;
import openfl.display.StageDisplayState;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

class Main extends Sprite {
	public static var instance:Main;
	static var worldScale:Float = 1 / 30;
	static var numFrames = 30;
	var physicsDebug:Sprite;
	var world:B2World;
	var ball:Actor;
	var terrains:Array<Actor> = [];
	var up = false;
	var left = false;
	var down = false;
	var right = false;
	var isOnTheGround = false;
	
	public function new() {
		super();
		instance = this;
		// stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
		world = new B2World(new B2Vec2(0, 10.0), true);
		physicsDebug = new Sprite();
		addChild(physicsDebug);
		var debugDraw = new B2DebugDraw();
		debugDraw.setSprite(physicsDebug);
		debugDraw.setDrawScale(1 / worldScale);
		debugDraw.setFlags(B2DebugDraw.e_shapeBit);
		world.setDebugDraw(debugDraw);
		world.setContactListener(new WorldContactListener());
		var screenWidth = stage.stageWidth;
		var screenHeight = stage.stageHeight;
		terrains.push(createBox(0, screenHeight - 20, screenWidth, 20, false));
		createBox(250, 100, 100, 100, true);
		createCircle(100, 100, 100, false);
		ball = createCircle(400, 100, 10, true);
		addEventListener(Event.ENTER_FRAME, update);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}

	public function checkBallOnTheGround(fixtureA:B2Fixture, fixtureB:B2Fixture) {
		var ballFixture = ball.getFixture();
		if (ballFixture == fixtureA) {
			for (terrain in terrains) {
				var terrainFixture = terrain.getFixture();
				if (terrainFixture == fixtureB) {
					isOnTheGround = true;
					return;
				}
			}
		} else if (ballFixture == fixtureB) {
			for (terrain in terrains) {
				var terrainFixture = terrain.getFixture();
				if (terrainFixture == fixtureA) {
					isOnTheGround = true;
					return;
				}
			}
		}
	}

	public function checkBallOffTheGround(fixtureA:B2Fixture, fixtureB:B2Fixture) {
		var ballFixture = ball.getFixture();
		if (ballFixture == fixtureA) {
			for (terrain in terrains) {
				var terrainFixture = terrain.getFixture();
				if (terrainFixture == fixtureB) {
					isOnTheGround = false;
					return;
				}
			}
		} else if (ballFixture == fixtureB) {
			for (terrain in terrains) {
				var terrainFixture = terrain.getFixture();
				if (terrainFixture == fixtureA) {
					isOnTheGround = false;
					return;
				}
			}
		}
	}
	
	function createBox(px:Float, py:Float, width:Float, height:Float, dynamicBody:Bool):Actor {
		var bodyDefinition = new B2BodyDef();
		bodyDefinition.position.set((px + width / 2) * worldScale, (py + height / 2) * worldScale);
		if (dynamicBody) {
			bodyDefinition.type = B2Body.b2_dynamicBody;
		}
		var polygon = new B2PolygonShape();
		polygon.setAsBox((width / 2) * worldScale, (height / 2) * worldScale);
		var fixtureDefinition = new B2FixtureDef();
		fixtureDefinition.shape = polygon;
		var body:B2Body = world.createBody(bodyDefinition);
		var fixture:B2Fixture = body.createFixture(fixtureDefinition);
		return new Actor(body, fixture);
	}
	
	
	function createCircle (px:Float, py:Float, radius:Float, dynamicBody:Bool):Actor {
		var bodyDefinition = new B2BodyDef();
		bodyDefinition.position.set(px * worldScale, py * worldScale);
		if (dynamicBody) {
			bodyDefinition.type = B2Body.b2_dynamicBody;
		}
		var circle = new B2CircleShape(radius * worldScale);
		var fixtureDefinition = new B2FixtureDef();
		fixtureDefinition.density = 0.5;
		fixtureDefinition.shape = circle;
		var body:B2Body = world.createBody(bodyDefinition);
		body.createFixture(fixtureDefinition);
		var fixture:B2Fixture = body.createFixture(fixtureDefinition);
		return new Actor(body, fixture);
	}

	function update(e:Event) {
		world.step(1 / numFrames, 10, 10);
		world.clearForces();
		world.drawDebugData();
		var center = new B2Vec2(0, 0);
		var ballBody = ball.getBody();
		if (left) {
			if (ballBody.getLinearVelocity().x > -7) {
				ballBody.applyForce(new B2Vec2(-2.0, 0.0), center);
			}
		}
		if (right) {
			if (ballBody.getLinearVelocity().x < 7) {
				ballBody.applyForce(new B2Vec2(2.0, 0.0), center);
			}
		}
		if (up) {
			if (isOnTheGround) {
				ballBody.applyImpulse(new B2Vec2(0.0, -1), center);
			}
		}
		if (down) {
			ballBody.applyForce(new B2Vec2(0.0, 0.15), center);
		}
	}

	function onKeyDown(e:KeyboardEvent) {
		switch (e.keyCode) {
			case Keyboard.W | Keyboard.UP:
				up = true;
			case Keyboard.A | Keyboard.LEFT:
				left = true;
			case Keyboard.S | Keyboard.DOWN:
				down = true;
			case Keyboard.D | Keyboard.RIGHT:
				right = true;
		}
	}

	function onKeyUp(e:KeyboardEvent) {
		switch (e.keyCode) {
			case Keyboard.W | Keyboard.UP:
				up = false;
			case Keyboard.A | Keyboard.LEFT:
				left = false;
			case Keyboard.S | Keyboard.DOWN:
				down = false;
			case Keyboard.D | Keyboard.RIGHT:
				right = false;
		}
	}
}