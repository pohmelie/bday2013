$(() ->

    $("body").css("background", "#293134")
    $("#message").css("color", "#e0e2e4")
    $("#skip").on("click", () -> win(true))

    img = new Image()
    ctx = $("#area")[0].getContext("2d")

    win = (skip=false) ->

        $("#area").off("click")
        $("#area").hide()
        $("#skip").hide()
        $("title").html("bday!")

        prefix = ""
        if skip

            prefix = "не"

        $("#message").css("width", img.width)
        $("#message").html("""
        Поздравляем, Вы #{prefix} прошли строжайший интеллектуальный отбор и
        приглашены на день рождения Никиты!<br>
        Соизвольте явиться 28 сентября (суббота) сего года в мою скромную
        усадьбу аккурат к 20 часам (кто забыл адрес — высылайте голубиную почту).
        На входе будет проведён строгий алкогольный контроль, у того у кого
        не будет обнаружен сосуд с увеселительным напитком возникнут проблемы
        со входом на бал.
        """)

        $("body").append("<br><img src=#{img.src}>")

    shuffle = () ->

        order_pass = false

        while not order_pass

            r = [0..14].map((i) -> [i, Math.random()]).sort((a, b) -> a[1] - b[1]).map((a) -> a[0])

            sum = 0
            for i in [0..13]

                for j in [(i + 1)..14]

                    if r[j] < r[i]

                        sum = sum + 1

            order_pass = (sum % 2 == 0)

        r.push(15)
        return r

    img.onload = (e) =>

        width = img.naturalWidth
        height = img.naturalHeight

        ctx.canvas.width  = width
        ctx.canvas.height = height

        ctx.drawImage(img, 0, 0)

        qw = Math.floor(width / 4)
        qh = Math.floor(height / 4)

        order = shuffle()
        boxes = []

        for i in [0..3]

            for j in [0..3]

                boxes.push(ctx.getImageData(j * qw, i * qh, qw, qh))


        redraw = (e) =>

            ctx.fillStyle = "#293134"
            ctx.fillRect(0, 0, width, height)

            for i in [0..15]

                x = i % 4
                y = Math.floor(i / 4)

                if order[i] != 15

                    ctx.putImageData(boxes[order[i]], x * qw, y * qh)

            ctx.lineWidth = 2
            ctx.strokeStyle = "#293134"

            for i in [0..4]

                ctx.moveTo(i * qw, 0)
                ctx.lineTo(i * qw, height)

                ctx.moveTo(0, i * qh)
                ctx.lineTo(width, i * qh)

            ctx.stroke()


        click = (e) =>

            x = Math.floor((e.pageX - e.target.offsetLeft) / qw)
            y = Math.floor((e.pageY - e.target.offsetTop) / qh)

            ei = order.indexOf(15)
            ex = ei % 4
            ey = Math.floor(ei / 4)

            for [cx, cy] in [[ex + 1, ey], [ex - 1, ey], [ex, ey + 1], [ex, ey - 1]]

                if cx == x and cy == y

                    i = x + y * 4
                    [order[i], order[ei]] = [order[ei], order[i]]
                    redraw()

                    if [0..15].every((i) -> order[i] == i)

                        win()

                    break


        $("#area").on("click", click)
        redraw()

    files = [
        "Acueducto_de_Segovia_01.png",
        "Brightly_lit_STS-135_on_launch_pad_39a.png",
        "Cabo_Espichel,_Portugal,_2012-08-18,_DD_08.png",
        "Furnadoia_de_Seceda_y_Resciesa.png",
        "Geirangerfjord_from_Ørnesvingen,_2013_June.png",
        "Grot_pavilion_in_Tsarskoe_Selo.png",
        "Måbødalen,_2011_August.png"
    ]
    img.src = files[Math.min(files.length - 1, Math.floor(Math.random() * files.length))]
)
