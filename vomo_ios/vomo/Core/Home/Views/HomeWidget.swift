//
//  HomeWidget.swift
//  VoMo
//
//  Created by Neil McGrogan on 5/18/22.
//

import SwiftUI

struct HomeWidget: View {
    let widget_img = "VoMo-App-Assets_2_8-cover-banner-img2"
    let quotes = Quotes()
    
    
    var body: some View {
        ZStack {
            Image(widget_img)
                .resizable()
                .scaledToFit()
            
            GeometryReader { geometry in
                VStack {
                    Color.gray.opacity(0)
                        .frame(height: geometry.size.height / 2)
                    VStack {
                        Text(quotes.findQuote())
                            .font(._coverBodyCopy)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 10)
                            .padding(.horizontal)
                        Spacer()
                    }
                    .frame(height: geometry.size.height / 2)
                }.frame(height: geometry.size.height)
            }
        }
    }
}

struct Quotes {
    let quote = [
        "\"Act as if what you do makes a difference. It does.\" - William James",
        "\"Success is not final, failure is not fatal: it is the courage to continue that counts.\" - Winston Churchill",
        "\"Never bend your head. Always hold it high. Look the world straight in the eye.\" - Helen Keller",
        "\"Believe you can and you're halfway there.\" - Theodore Roosevelt",
        "\"When you have a dream, you've got to grab it and never let go.\" - Carol Burnett",
        "\"I can't change the direction of the wind, but I can adjust my sails to always reach my destination.\" - Jimmy Dean",
        "\"What you get by achieving your goals is not as important as what you become by achieving your goals.\" - Zig Ziglar",
        "\"No matter what you're going through, there's a light at the end of the tunnel.\" - Demi Lovato",
        "\"It is our attitude at the beginning of a difficult task which, more than anything else, will affect its successful outcome.\" - William James",
        "\"Life is like riding a bicycle. To keep your balance, you must keep moving.\" - Albert Einstein",
        "\"Sometimes you will never know the value of a moment, until it becomes a memory.\" - Dr. Seuss",
        "\"You do not find the happy life. You make it.\" - Camilla Eyring Kimball",
        "\"Just don't give up trying to do what you really want to do. Where there is love and inspiration, I don't think you can go wrong.\" - Ella Fitzgerald",
        "\"Nothing is impossible. The word itself says 'I'm possible!'\" - Audrey Hepburn",
        "\"You are never too old to set another goal or to dream a new dream.\" - C.S. Lewis",
        "\"Try to be a rainbow in someone else's cloud.\" - Maya Angelou",
        "\"It isn't where you came from. It's where you're going that counts.\" - Ella Fitzgerald",
        "\"Inspiration comes from within yourself. One has to be positive. When you're positive, good things happen.\" - Deep Roy",
        "\"The most wasted of days is one without laughter.\" - E. E. Cummings",
        "\"You must do the things you think you cannot do.\" - Eleanor Roosevelt",
        "\"It is never too late to be what you might have been.\" - George Eliot",
        "\"Stay close to anything that makes you glad you are alive.\" - Hafez",
        "\"Some people look for a beautiful place. Others make a place beautiful.\" -Hazrat Inayat Khan",
        "\"Happiness is not by chance, but by choice.\" - Jim Rohn",
        "\"Never limit yourself because of others' limited imagination; never limit others because of your own limited imagination.\" - Mae Jemison",
        "\"You don't always need a plan. Sometimes you just need to breathe, trust, let go, and see what happens.\" - Mandy Hale",
        "\"Be the change that you wish to see in the world.\" - Mahatma Gandhi",
        "\"The bad news is time flies. The good news is you're the pilot.\" - Michael Altshuler",
        "\"My mission in life is not merely to survive, but to thrive.\" - Maya Angelou",
        "\"If you look at what you have in life, you'll always have more.\" - Oprah Winfrey",
        "\"Don't wait. The time will never be just right.\" - Napoleon Hill",
        "\"Spread love everywhere you go.\" - Mother Teresa",
        "\"Inspiration is some mysterious blessing which happens when the wheels are turning smoothly.\" - Quentin Blake",
        "\"No matter what people tell you, words and ideas can change the world.\" - Robin Williams",
        "\"There is nothing impossible to him who will try.\" - Alexander the Great",
        "\"Happiness often sneaks in through a door you didn't know you left open.\" - John Barrymore",
        "\"We must be willing to let go of the life we planned so as to have the life that is waiting for us.\" - Joseph Campbell",
        "\"Life changes very quickly, in a very positive way, if you let it.\" - Lindsey Vonn",
        "\"Keep your face to the sunshine and you cannot see a shadow.\" - Helen Keller",
        "\"Life has got all those twists and turns. You've got to hold on tight and off you go.\" - Nicole Kidman",
        "\"A champion is defined not by their wins but by how they can recover when they fall.\" - Serena Williams",
        "\"Motivation comes from working on things we care about.\" - Sheryl Sandberg",
        "\"It is during our darkest moments that we must focus to see the light.\" - Aristotle",
        "\"Let us make our future now, and let us make our dreams tomorrow's reality.\" - Malala Yousafzai",
        "\"If I cannot do great things, I can do small things in a great way.\" - Martin Luther King Jr.",
        "\"You are enough just as you are.\" - Meghan Markle",
        "\"With the right kind of coaching and determination you can accomplish anything.\" - Reese Witherspoon",
        "\"If you have good thoughts they will shine out of your face like sunbeams, and you will always look lovely.\" - Roald Dahl",
        "\"Each person must live their life as a model for others.\" - Rosa Parks",
        "\"The power of imagination makes us infinite.\" - John Muir",
        "\"When you’re in a dark place, you sometimes tend to think you’ve been buried. Perhaps you’ve been planted. Bloom.\"",
    ]
    
    func findQuote() -> String {
        return quote[Int.random(in: 0...quote.count - 1)]
    }
}
