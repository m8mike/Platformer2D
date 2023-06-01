import box2D.dynamics.B2ContactListener;
import box2D.dynamics.contacts.B2Contact;
import box2D.dynamics.B2ContactImpulse;
import box2D.collision.B2Manifold;

class WorldContactListener extends B2ContactListener {	
	override public function beginContact(contact:B2Contact) {
        //trace(contact);
        if (contact.isTouching()) {
            Main.instance.checkBallOnTheGround(contact.getFixtureA(), contact.getFixtureB());
        }
    }

    override public function endContact(contact:B2Contact) {
        //trace(contact);
        Main.instance.checkBallOffTheGround(contact.getFixtureA(), contact.getFixtureB());
    }
    
    override public function preSolve(contact:B2Contact, oldManifold:B2Manifold) {
        //trace(contact);
    }
    
    override public function postSolve(contact:B2Contact, impulse:B2ContactImpulse) {
        //trace(contact);
    }
}