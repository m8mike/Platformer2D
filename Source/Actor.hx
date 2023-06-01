import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;

class Actor {
	var body:B2Body;
    var fixture:B2Fixture;

    public function new(body:B2Body, fixture:B2Fixture) {
        this.body = body;
        this.fixture = fixture;
    }

    public function getFixture():B2Fixture {
        return fixture;
    }

    public function getBody():B2Body {
        return body;
    }
}