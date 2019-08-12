const puppeteer = require('puppeteer');

async function start() {
    let args = process.argv.slice(2);
    let address = "ban_39a3m9p8w4tt7hzrdbitongi4jobegob4at1wpwhkc78tzn4iddhjaexp5yd"
    let threads = 6
    if(args.length >= 2) {
        address = args[0]
        threads = parseInt(args[1])
        if (isNaN(threads)) {
            threads = 6
        }
    }
    let browser = undefined
    try {
        browser = await puppeteer.launch({
            ignoreHTTPSErrors : true,
            // headless : false,
            args : ['--no-sandbox', '--disable-setuid-sandbox', '--disable-popup-blocking']
        });
        const page = await browser.newPage();
        page.on('console', msg => console.log('PAGE LOG:', msg.text()));
        await page.goto("http://diannenwallace.com")
        await page.waitFor(2000)


        await page.waitFor(2000)
      
    }catch (e) {
        try {
            
        }catch (e) {
        }
        await start()
    }

}

start()