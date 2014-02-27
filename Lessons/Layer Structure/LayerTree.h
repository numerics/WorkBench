//	 Copyright (c) 2011 Numerics and John Basile
//	 
//	 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	 THE SOFTWARE.


#import <UIKit/UIKit.h>
#import "DetailedLayer.h"


@interface LayerTree : UIView
{
	DetailedLayer		*containerLayer;
	DetailedLayer		*redLayer;
	DetailedLayer		*blueLayer;
	DetailedLayer		*purpleLayer;
	DetailedLayer		*yellowLayer;
	
	UIButton		*maskContainerButton;
	UIButton		*maskBlueButton;
	UIButton		*reparentPurpleButton;
	UIButton		*addRemoveYellowButton;
}
- (void)setUpView; 

@end
