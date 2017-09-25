//
//  NFTermsDataSource.m
//  NesiaFerdman
//
//  Created by Alex_Shitikov on 9/25/17.
//  Copyright © 2017 Gemicle. All rights reserved.
//

#import "NFTermsDataSource.h"


@implementation NFTermsDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mainInfo = [NSString stringWithFormat:@"Добро пожаловать в My Date!\n\n"
                         "Благодарим за использование нашего продукта. "
                         "Используя наше приложение, вы соглашаетесь с настоящими Условиями. Просим вас внимательно ознакомиться с ними.\n\n"
                         "Использование My Date\n\n"
                         "Вы должны соблюдать все правила, с которыми вам будет предложено ознакомиться при использовании приложения.\n\n"
                         "Не используйте приложения ненадлежащим образом. В частности, не пытайтесь вмешаться в их работу или получить к ним доступ в обход стандартного интерфейса и наших инструкций. Используйте приложения только в соответствии с нормами законодательства, включая применимые нормативные акты и правила относительно экспорта и реэкспорта. Если вы будете нарушать данные условия и правила или если мы заподозрим вас в этом, мы можем приостановить или полностью закрыть вам доступ к приложению.\n\n"
                         "При работе с приложением вам не предоставляются права на интеллектуальную собственность ни на само приложения, ни на связанное с ними содержание. Последнее вы можете использовать только в том случае, если у вас есть разрешение его владельца или если такая возможность обеспечивается законодательством. Настоящие условия не предоставляют вам прав на использование каких-либо элементов брендинга или логотипов нашего приложения. Вы не должны удалять, скрывать или изменять юридические уведомления, отображаемые на страницах приложения.\n\n"
                         "Эта политика конфиденциальности предоставляет вам информацию о том, как мы собираем, храним и обрабатываем данные. В целом мы различаем личную и неличную информацию. Мы не продаем и не позволяем другим третьим лицам использовать ваши данные. Пожалуйста, найдите информацию о том, как мы можем обработать ее ниже.\n\n"
                         "Использование персональных данных\n\n"
                         "Когда вы отправляете электронное письмо в поддержку My Date, мы сохраняем отчет о нашем сообщении. Это включает в себя вашу электронную почту и историю разговоров. Это единственная личная информация, которую мы собираем, и она помогает нам разрабатывать, поставлять, защищать и совершенствовать наши продукты, услуги, контент и общение с клиентами.\n\n"
                         "Использование личных данных\n\n"
                         "Личная информация - это анонимные данные, с которыми вы не можете однозначно идентифицировать конкретного человека. Сюда входит следующая информация:\n"
                         "- Информация о Google account\n"
                         "- Вся информация с Google calendar\n\n"
                         "Использование других услуг\n\n"
                         "My Date использует Google Calendar API для синхронизации с Google Calendar.\n\n"
                         "Приложение My Date не несет ответственность за изменения в Вашей личной жизни.\n\n"];
    }
    return self;
}


@end
