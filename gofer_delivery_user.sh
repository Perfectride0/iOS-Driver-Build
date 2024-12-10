#!/usr/bin/env bash


sudo rm -rf GoferDriver/Main/Go\ Jek/GoferDeliveryAll
sudo rm -rf GoferDriver/Main/Go\ Jek/Laundry
sudo rm -rf GoferDriver/Main/Go\ Jek/InstaCart
sudo rm -rf GoferDriver/Main/Go\ Jek/Handy
#sudo rm -rf GoferDriver/Main/Go\ Jek/Gofer
sudo rm -rf GoferDriver/Main/Go\ Jek/GoferTow
sudo rm -rf GoferDriver/Main/Go\ Jek/Delivery

#                / New_Delivery_splitup_Start/
#                / New_Delivery_splitup_End/

#
#           '/start/,/end/d'
#//           \/Delivery\_NewSplitup\_Start/
#//           \/Delivery\_NewSplitup\_End/


#FOR DELIVERYALL
#find . -name "*.swift" -exec sed -i '' '/Deliveryall\_Newsplitup\_start/,/Deliveryall\_Newsplitup\_end/d' '{}' \;
#FOR GOFER
find . -name "*.swift" -exec sed -i '' '/Gofer\_NewSplitup\_start/,/Gofer\_NewSplitup\_end/d' '{}' \;
#find . -name "*.swift" -exec sed -i '/GoferDeliveryAll\_Start/,/GoferDeliveryAll\_End/d' '{}' \;
#find . -name "*.php" -exec sed -i '/GoferDeliveryAll\_Start/,/GoferDeliveryAll\_End/d' '{}' \;


#//				.xml
#//           <!--/**GoferDeliveryAll_NoNeed_Start**/-->
#//           <!--/**GoferDeliveryAll_NoNeed_End**/-->

#//           \<\!\-\-\/\*\*\GoferDeliveryAll\_NoNeed\_Start\*\*\/\-\-\>
#//           \<\!\-\-\/\*\*\GoferDeliveryAll\_NoNeed\_End\*\*\/\-\-\>

#//   find . -name "*.xml" -exec sed -i '/\<\!\-\-\/\*\*\GoferDeliveryAll\_NoNeed\_Start\*\*\/\-\-\>/,/\<\!\-\-\/\*\*\GoferDeliveryAll\_NoNeed\_End\*\*\/\-\-\>/d' '{}' \;

#find . -name "*.xml" -exec sed -i '/GoferDeliveryAll\_NoNeed\_Start/,/GoferDeliveryAll\_NoNeed\_End/d' '{}' \;

