//
//  PreviewProvider.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 20.02.2023.
//

import SwiftUI

class DeveloperPreview{
    static let instance = DeveloperPreview()
    
    let collections = Category.allCases.map{$0.rawValue}
    
    private init(){}
    
    let cards = [
        PaymentCard(id: UUID().uuidString, cardNumber: "8794_6574_1239_0475_1239", expirationMonth: "03", expirationYear: "24", cvv: "584", inUse: false),
        PaymentCard(id: UUID().uuidString, cardNumber: "8794_6574_1239_0475_6067", expirationMonth: "02", expirationYear: "25", cvv: "564", inUse: true),
        PaymentCard(id: UUID().uuidString, cardNumber: "8794_6574_1239_0475_8794", expirationMonth: "11", expirationYear: "23", cvv: "184", inUse: false),
    ]
    
    let user = User(
        id: UUID().uuidString,
        profileImage: "john-wick",
        firstName: "Adilzhan",
        lastName: "Rymbayev",
        email: "ruslan.zhakiyanov@mail.ru",
        birthDate: Calendar.current.date(from: DateComponents(calendar: Calendar.current, year: 2001, month: 8, day: 2))!,
        phoneNumber: "7-(747)-469-02-94",
        gender: "Male")
    
    let restaurant = Restaurant(id: UUID().uuidString,
                                name: "Palazzo Hotel",
                                address: Address(city: "Almaty",
                                                 location: "9613 Bellevue St.Athens, GA 30605",
                                                 latitude: 41.8902,
                                                 longitude: 12.4922),
                                image: "restaurant1",
                                rating: 4.8,
                                reviewAmount: 4563,
                                reserveAmount: 15000,
                                bookmarked: false,
                                bookingStatus: .cancelled)
    
    let details = RestaurantDetails(
        id: UUID().uuidString,
        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus auctor lacus ac lobortis vulputate. Sed eu sodales nunc, vitae tincidunt ligula. Donec sit amet maximus libero. Mauris dignissim elit tellus, sit amet vehicula arcu aliquet ac. Ut vestibulum lacus magna, nec vulputate elit efficitur sit amet. Nunc non vestibulum ipsum. Duis metus nisl, ornare at mauris non, posuere dapibus ante. Ut lobortis suscipit quam, vel tristique augue scelerisque id. Quisque fringilla velit eget magna pulvinar, at commodo nunc finibus. Integer ac sem eu ipsum finibus rhoncus ac et elit.Quisque id mauris eu eros euismod hendrerit. Nam at rhoncus elit. Pellentesque consequat, sapien sit amet faucibus gravida, ex est scelerisque tellus, quis imperdiet ligula metus at metus. Donec maximus tortor urna, eu luctus leo sodales eget. Nam in laoreet eros, at porta nisi. Quisque vitae leo nibh. Aliquam volutpat feugiat tellus, ut luctus nisl sodales et. Quisque placerat massa quis enim lobortis convallis. Nunc aliquam odio sed dictum tincidunt. Maecenas turpis augue, vehicula id condimentum at, condimentum vitae mauris. Nam finibus arcu sed ex consectetur, nec tincidunt libero commodo. Duis ligula magna, posuere sit amet ultrices et, egestas posuere lacus. Aenean dapibus rhoncus tortor nec varius. Vivamus vel enim eu lorem mattis dapibus sit amet non lectus. Aliquam non euismod ligula. Maecenas ullamcorper, enim nec elementum consequat, mauris nisi tempus nisl, fermentum dictum justo quam quis leo.",
        categories: [],
        phoneNumber: "7-(747)-469-02-94",
        instragramLink: "https://google.com",
        metaLink: "https://google.com",
        commentRatingStatus: [0.8, 0.7, 0, 0.1, 0])
    
    let restaurants = [
        Restaurant(id: UUID().uuidString,
                   name: "Palazzo Hotel",
                   address: Address(city: "Almaty",
                                    location: "9613 Bellevue St.Athens, GA 30605",
                                    latitude: 41.8986,
                                    longitude: 12.4769),
                   image: "restaurant1",
                   rating: 4.8,
                   reviewAmount: 4563,
                   reserveAmount: 15000,
                   bookmarked: false,
                   bookingStatus: .ongoing),
        
        Restaurant(id: UUID().uuidString,
                   name: "Bulgari Hotel",
                   address: Address(city: "Almaty",
                                    location: "940 N. Delaware Road Uniondale, NY 11553",
                                    latitude: 41.9009,
                                    longitude: 12.4833),
                   image: "restaurant2",
                   rating: 3.7,
                   reviewAmount: 1563,
                   reserveAmount: 5000,
                   bookmarked: false,
                   bookingStatus: .cancelled),
        
        Restaurant(id: UUID().uuidString,
                   name: "Amsterdam, Netherlands",
                   address: Address(city: "Almaty",
                                    location: "4 West Alton Avenue Torrance, CA 90505",
                                    latitude: 48.8584,
                                    longitude: 2.2945),
                   image: "restaurant3",
                   rating: 4.7,
                   reviewAmount: 4563,
                   reserveAmount: 19000,
                   bookmarked: true,
                   bookingStatus: .completed),
        
        Restaurant(id: UUID().uuidString,
                   name: "Martinez Channes Hotel",
                   address: Address(city: "Almaty",
                                    location: "62 Shadow Brook Lane Fenton, MI 48430",
                                    latitude: 48.8606,
                                    longitude: 2.3376),
                   image: "restaurant4",
                   rating: 2.7,
                   reviewAmount: 563,
                   reserveAmount: 4000,
                   bookmarked: false,
                   bookingStatus: .completed),
        
        Restaurant(id: UUID().uuidString,
                   name: "Palms Casino Hotel",
                   address: Address(city: "Almaty",
                                    location: "9613 Bellevue St.Athens, GA 30605",
                                    latitude: 44.8606,
                                    longitude: 5.3376),
                   image: "restaurant5",
                   rating: 2.9,
                   reviewAmount: 563,
                   reserveAmount: 7000,
                   bookmarked: false,
                   bookingStatus: .cancelled),
        
        Restaurant(id: UUID().uuidString,
                   name: "London, UK",
                   address: Address(city: "Almaty",
                                    location: "20 Bridgeton St.Thibodaux, LA 70301",
                                    latitude: 44.8606,
                                    longitude: 1.3376),
                   image: "restaurant6",
                   rating: 4.1,
                   reviewAmount: 3563,
                   reserveAmount: 17000,
                   bookmarked: true,
                   bookingStatus: .ongoing),
        
        Restaurant(id: UUID().uuidString,
                   name: "Martinez Channes Hotel",
                   address: Address(city: "Almaty",
                                    location: "62 Shadow Brook Lane Fenton, MI 48430",
                                    latitude: 24.8606,
                                    longitude: 1.9376),
                   image: "restaurant7",
                   rating: 2.7,
                   reviewAmount: 563,
                   reserveAmount: 4000,
                   bookmarked: false,
                   bookingStatus: .cancelled),
    ]
    
    let comments = [
        Comment(
            id: UUID().uuidString,
            date: Date().description,
            user: User(
                id: UUID().uuidString,
                profileImage: "john-wick",
                firstName: "Ruslan",
                lastName: "Zhakiyanov",
                email: "ruslan.zhakiyanov@mail.ru",
                birthDate: Calendar.current.date(from: DateComponents(calendar: Calendar.current, year: 2001, month: 8, day: 2))!,
                phoneNumber: "7-(747)-469-02-94",
                gender: "Male"),
            text: "I recently visited this restaurant and was blown away by the quality of the food! The flavors were perfectly balanced, and everything was cooked to perfection. The service was also excellent, with friendly and attentive staff who made sure we had everything we needed. I highly recommend this restaurant to anyone looking for a top-notch dining experience!",
            rating: 5),
        Comment(
            id: UUID().uuidString,
            date: Date().description,
            user: User(
                id: UUID().uuidString,
                profileImage: "john-wick",
                firstName: "Azamat",
                lastName: "Bektursyn",
                email: "ruslan.zhakiyanov@mail.ru",
                birthDate: Calendar.current.date(from: DateComponents(calendar: Calendar.current, year: 2001, month: 8, day: 2))!,
                phoneNumber: "7-(747)-469-02-94",
                gender: "Male"),
            text: "I had such a wonderful experience dining at this restaurant! The ambiance was cozy and welcoming, and the menu had a great variety of options to choose from. I ended up ordering the chef's special and was not disappointed! The dish was beautifully presented and tasted absolutely delicious. The staff were also very knowledgeable about the menu and gave great recommendations. I will definitely be returning to this restaurant soon!",
            rating: 3),
        Comment(
            id: UUID().uuidString,
            date: Date().description,
            user: User(
                id: UUID().uuidString,
                profileImage: "",
                firstName: "Adilzhan",
                lastName: "Rymbayev",
                email: "ruslan.zhakiyanov@mail.ru",
                birthDate: Calendar.current.date(from: DateComponents(calendar: Calendar.current, year: 2001, month: 8, day: 2))!,
                phoneNumber: "7-(747)-469-02-94",
                gender: "Male"),
            text: "I stumbled upon this hidden gem of a restaurant and was blown away by the amazing food! The dishes were creative and packed with flavor, and the presentation was beautiful. The atmosphere was also fantastic, with a cozy and romantic vibe that made for a perfect date night. The staff were attentive and friendly, and overall it was a wonderful dining experience. I highly recommend giving this restaurant a try!",
            rating: 4),
    ]
    
    let filterData = FilterProvider.shared
    
    let foods = [
        Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"),
        Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"),
        Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"),
        Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"),
        Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"),
        Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"),
        Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"),
        Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"),
        Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"),
        Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"),
        Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"),
        Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce")
    ]
    
    let food = Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce")
    
    let orderedFoods = [
        OrderedFood(id: UUID().uuidString, food: Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"), count: 1, price: 2890, specialWishes: ""),
        OrderedFood(id: UUID().uuidString, food: Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"), count: 2, price: 2890, specialWishes: ""),
        OrderedFood(id: UUID().uuidString, food: Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"), count: 5, price: 2890, specialWishes: ""),
        OrderedFood(id: UUID().uuidString, food: Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"), count: 2, price: 2890, specialWishes: ""),
        OrderedFood(id: UUID().uuidString, food: Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"), count: 3, price: 2890, specialWishes: ""),
    ]
    
//    var bookingRestaurant: BookingRestaurant{
//        var availableTimeInterval = [Date: [Date]]()
//        let today = Calendar.current.startOfDay(for: Date())
//        let tomorrow = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
//        let theDayAfterTomorrow = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 2, to: Date())!)
//        availableTimeInterval[today] = createTimeInterval(from: createDay(from: Date()))
//        availableTimeInterval[tomorrow] = createTimeInterval(from: tomorrow)
//        availableTimeInterval[theDayAfterTomorrow] = createTimeInterval(from: theDayAfterTomorrow)
//
//        var prices = [Date: [Double]]()
//        for i in availableTimeInterval.keys{
//            createPricesForEachDate(for: &prices, from: availableTimeInterval[i]!, date: i)
//        }
//
//        return BookingRestaurant(id: UUID().uuidString, maxGuestNumber: 10, availableBookingTimeInterval: availableTimeInterval, prices: prices, pricePerGuest: 1200.0)
//    }
    
    var bookedRestaurant: BookedRestaurant{
        return BookedRestaurant(id: UUID().uuidString, restaurant: Restaurant(id: UUID().uuidString,
                                                                              name: "Palazzo Hotel",
                                                                              address: Address(city: "Almaty",
                                                                                               location: "9613 Bellevue St.Athens, GA 30605",
                                                                                               latitude: 41.8902,
                                                                                               longitude: 12.4922),
                                                                              image: "restaurant1",
                                                                              rating: 4.8,
                                                                              reviewAmount: 4563,
                                                                              reserveAmount: 15000,
                                                                              bookmarked: false,
                                                                              bookingStatus: .cancelled), numberOfGuests: 5, selectedDate: Date(), selectedTime: Date().formatted(date: .omitted, time: .shortened), specialWishes: "under A/C")
    }
    
    let reservedRestaurantDetail = ReservedRestaurantDetail(id: UUID().uuidString, restaurantName: "Eldora", restaurantImage: "restaurant1", city: "Almaty", location: "Momushuly, 83", tableNumber: 55, reservedDate: "Mar 31", reservedTime: "18:00", numberOfGuests: 3, specialWishes: "Lit the fire on cake", orderedFoods: [
        OrderedFood(id: UUID().uuidString, food: Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"), count: 1, price: 2890, specialWishes: ""),
        OrderedFood(id: UUID().uuidString, food: Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"), count: 2, price: 2890, specialWishes: ""),
        OrderedFood(id: UUID().uuidString, food: Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"), count: 5, price: 2890, specialWishes: ""),
        OrderedFood(id: UUID().uuidString, food: Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"), count: 2, price: 2890, specialWishes: ""),
        OrderedFood(id: UUID().uuidString, food: Food(id: UUID().uuidString, name: "Caesar salad with grilled chicken", image: "salad", type: FoodType(id: UUID().uuidString, type: "salad"), price: 2890, description: "lettuce, pieces of chicken meat (usually breast), crackers, grated parmesan, Caesar sauce"), count: 3, price: 2890, specialWishes: ""),
    ], restaurantBookingPrice: 1700.0, orderedFoodsPrice: 6700.0, servicePrice: 514.0, totalPrice: 8445.0)
    
    let scheme = RestaurantScheme(
        id: "123",
        numberOfRows: 8,
        numberOfColumns: 12,
        floors: [
            Floor(
                id: "1",
                groups:
                    [MapItemGroup(
                        id: "1",
                        reserved: false,
                        tableItem: [MapItem(id: UUID().uuidString, type: .TABLE, items: [Point(x: 1, y: 1)])],
                        chairItems: [MapItem(id: UUID().uuidString, type: .CHAIR, items: [Point(x: 1, y: 2)]), MapItem(id: UUID().uuidString, type: .CHAIR, items: [Point(x: 2, y: 1)])],
                        sofaItems: [MapItem(id: UUID().uuidString, type: .SOFA, items: [Point(x: 0, y: 1), Point(x: 0, y: 0), Point(x: 1, y: 0)])]),
                     MapItemGroup(id: "2",
                                  reserved: true,
                                   tableItem: [
                                     MapItem(id: UUID().uuidString,
                                                       type: .TABLE,
                                                       items: [
                                                         Point(x: 3, y: 4),
                                                         Point(x: 4, y: 4),
                                                         Point(x: 5, y: 4),
                                                         Point(x: 6, y: 4),
                                                       ])
                                   ],
                                   chairItems: [
                                     MapItem(id: UUID().uuidString,type: .CHAIR, items: [Point(x: 4, y: 3)]),
                                     MapItem(id: UUID().uuidString,type: .CHAIR, items: [Point(x: 5, y: 3)]),
                                     MapItem(id: UUID().uuidString,type: .CHAIR, items: [Point(x: 7, y: 4)]),
                                     MapItem(id: UUID().uuidString,type: .CHAIR, items: [Point(x: 2, y: 4)]),
                                     MapItem(id: UUID().uuidString,type: .CHAIR, items: [Point(x: 4, y: 5)]),
                                     MapItem(id: UUID().uuidString,type: .CHAIR, items: [Point(x: 5, y: 5)])
                                   ],
                                   sofaItems: []),
                     MapItemGroup(id: "3",
                                  reserved: false,
                                   tableItem: [
                                     MapItem(id: UUID().uuidString,
                                                       type: .TABLE,
                                                       items: [
                                                         Point(x: 8, y: 1),
                                                         Point(x: 9, y: 1),
                                                         Point(x: 10, y: 1),
                                                         Point(x: 11, y: 1),
                                                         Point(x: 11, y: 2),
                                                         Point(x: 11, y: 3),
                                                         Point(x: 10, y: 3),
                                                         Point(x: 9, y: 3),
                                                         Point(x: 8, y: 3),
                                                         Point(x: 8, y: 2),
                                                       ])
                                   ],
                                   chairItems: [],
                                   sofaItems: []),
                     MapItemGroup(id: "4",
                                  reserved: false,
                                   tableItem: [
                                     MapItem(id: UUID().uuidString,
                                                       type: .TABLE,
                                                       items: [
                                                         Point(x: 7, y: 7),
                                                         Point(x: 8, y: 7),
                                                         Point(x: 9, y: 7),
                                                         Point(x: 10, y: 7),
                                                         Point(x: 10, y: 8),
                                                         Point(x: 9, y: 8),
                                                         Point(x: 8, y: 8),
                                                         Point(x: 7, y: 8),
                                                         Point(x: 7, y: 9),
                                                         Point(x: 8, y: 9),
                                                         Point(x: 9, y: 9),
                                                         Point(x: 10, y: 9),
                                                       ])
                                   ],
                                   chairItems: [],
                                   sofaItems: [])],
                walls: [],
                map: [
//                    0    1    2    3    4    5    6    7    8    9   10    11
                    ["s", "s", "w", "w", "w", "w", "w", "w", "w", "w", "w", "w"], // 0
                    ["s", "t", "c", "*", "*", "*", "*", "*", "t", "t", "t", "t"], // 1
                    ["w", "c", "*", "*", "*", "*", "*", "*", "t", "*", "*", "t"], // 2
                    ["w", "*", "*", "*", "c", "c", "*", "*", "t", "t", "t", "t"], // 3
                    ["w", "*", "c", "t", "t", "t", "t", "c", "*", "*", "*", "w"], // 4
                    ["w", "*", "*", "*", "c", "c", "*", "*", "*", "*", "*", "w"], // 5
                    ["w", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "w"], // 6
                    ["w", "s", "*", "*", "*", "*", "*", "t", "t", "t", "t", "w"], // 7
                    ["w", "s", "*", "*", "*", "*", "*", "t", "t", "t", "t", "w"], // 8
                    ["w", "s", "*", "*", "*", "*", "*", "t", "t", "t", "t", "w"]  // 9
                ]
            ),
            Floor(
                id: "2",
                groups:
                    [MapItemGroup(
                        id: "7",
                        reserved: false,
                        tableItem: [MapItem(id: UUID().uuidString, type: .TABLE, items: [Point(x: 1, y: 1)])],
                        chairItems: [MapItem(id: UUID().uuidString, type: .CHAIR, items: [Point(x: 1, y: 2)]), MapItem(id: UUID().uuidString, type: .CHAIR, items: [Point(x: 2, y: 1)])],
                        sofaItems: [MapItem(id: UUID().uuidString, type: .SOFA, items: [Point(x: 0, y: 1), Point(x: 0, y: 0), Point(x: 1, y: 0)])]),
                     MapItemGroup(id: "8",
                                  reserved: true,
                                   tableItem: [
                                     MapItem(id: UUID().uuidString,
                                                       type: .TABLE,
                                                       items: [
                                                         Point(x: 3, y: 4),
                                                         Point(x: 4, y: 4),
                                                         Point(x: 5, y: 4),
                                                         Point(x: 6, y: 4),
                                                       ])
                                   ],
                                   chairItems: [
                                     MapItem(id: UUID().uuidString,type: .CHAIR, items: [Point(x: 4, y: 3)]),
                                     MapItem(id: UUID().uuidString,type: .CHAIR, items: [Point(x: 5, y: 3)]),
                                     MapItem(id: UUID().uuidString,type: .CHAIR, items: [Point(x: 7, y: 4)]),
                                     MapItem(id: UUID().uuidString,type: .CHAIR, items: [Point(x: 2, y: 4)]),
                                     MapItem(id: UUID().uuidString,type: .CHAIR, items: [Point(x: 4, y: 5)]),
                                     MapItem(id: UUID().uuidString,type: .CHAIR, items: [Point(x: 5, y: 5)])
                                   ],
                                   sofaItems: []),
                     MapItemGroup(id: "9",
                                  reserved: false,
                                   tableItem: [
                                     MapItem(id: UUID().uuidString,
                                                       type: .TABLE,
                                                       items: [
                                                         Point(x: 8, y: 1),
                                                         Point(x: 9, y: 1),
                                                         Point(x: 10, y: 1),
                                                         Point(x: 11, y: 1),
                                                         Point(x: 11, y: 2),
                                                         Point(x: 11, y: 3),
                                                         Point(x: 10, y: 3),
                                                         Point(x: 9, y: 3),
                                                         Point(x: 8, y: 3),
                                                         Point(x: 8, y: 2),
                                                       ])
                                   ],
                                   chairItems: [],
                                   sofaItems: [])],
                walls: [],
                map: [
//                    0    1    2    3    4    5    6    7    8    9   10    11
                    ["s", "s", "w", "w", "w", "w", "w", "w", "w", "w", "w", "w"], // 0
                    ["s", "t", "c", "*", "*", "*", "*", "*", "t", "t", "t", "t"], // 1
                    ["w", "c", "*", "*", "*", "*", "*", "*", "t", "*", "*", "t"], // 2
                    ["w", "*", "*", "*", "c", "c", "*", "*", "t", "t", "t", "t"], // 3
                    ["w", "*", "c", "t", "t", "t", "t", "c", "*", "*", "*", "w"], // 4
                    ["w", "*", "*", "*", "c", "c", "*", "*", "*", "*", "*", "w"], // 5
                    ["w", "*", "*", "*", "*", "*", "*", "*", "*", "*", "*", "w"], // 6
                    ["w", "s", "*", "*", "*", "*", "*", "t", "t", "t", "t", "w"], // 7
                    ["w", "s", "*", "*", "*", "*", "*", "t", "t", "t", "t", "w"], // 8
                    ["w", "s", "*", "*", "*", "*", "*", "t", "t", "t", "t", "w"]  // 9
                ]
            )
        ]
    )
    
    let tableInfo = TableInfo(id: UUID().uuidString,
                              floor: 1,
                              numberOfChairs: 6,
                              reservePrice: 1350.0,
                              availableTimeInterval: [
                                "10:30",
                                "12:30",
                                "15:00",
                                "17:00"
                              ],
                              description: "Table #5 is a cozy, round table located in the corner of the restaurant. It's perfect for intimate dinners or small gatherings with friends. The table is made of polished wood and has comfortable chairs upholstered in a soft, cream-colored fabric. The table is set with crisp white linens, sparkling silverware, and elegant wine glasses. ",
                              images: ["table1", "table2", "table3"])
}

extension DeveloperPreview{
    class FilterProvider{
        static let shared = FilterProvider()
        private init(){}
        
        let availableCities = ["Almaty", "Astana", "Semey", "Takdykorgan", "Oskemen", "Aktau", "Shymkent"]
        let categories = Category.allCases.map{$0.rawValue}
        let availableRatings = [5, 4, 3, 2, 1]
        let availableFacilities = ["Wi-Fi", "Parking", "Terassa", "Blues"]
        let accomodationTypes = ["Pizzerias", "Cafés", "Fast casual restaurants", "Casual dining restaurants"]
    }
    
    //MARK: - Booking Restaurant date builder
    private func createPricesForEachDate(for prices: inout [Date: [Double]], from dateArray: [Date], date: Date) {
        let initialPrice = 1500.0
        var factor = 0.0
        prices[date] = [Double]()
        for _ in dateArray {
            prices[date]?.append(initialPrice + factor)
            factor += 250.0
        }
    }
    private func createTimeInterval(from date: Date) -> [Date]{
        var dateArray = [Date]()
        let calendar = Calendar.current
        let startDate = date
        let endDate = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: startDate)!)
        let interval = TimeInterval(30 * 60)
        var currentDate = startDate

        while currentDate <= endDate {
            dateArray.append(currentDate)
            currentDate = calendar.date(byAdding: .second, value: Int(interval), to: currentDate)!
        }

        // If the last date added to the array is after midnight, remove it
        if let lastDate = dateArray.last, calendar.isDate(lastDate, inSameDayAs: endDate) == false {
            dateArray.removeLast()
        }
        return dateArray
    }
    private func createDay(from date: Date) -> Date{
        let startDate = date

        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: startDate)
        let roundedMinutes = 5 * Int((Float(minutes) / 5.0).rounded())
        return calendar.date(bySetting: .minute, value: roundedMinutes, of: startDate)!
    }
}

extension PreviewProvider{
    
    static var dev: DeveloperPreview{
        return DeveloperPreview.instance
    }
}
