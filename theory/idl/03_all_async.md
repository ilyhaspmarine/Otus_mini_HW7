# IDL: Полностью синхронная архитектура (HTTP)

## HTTP API

### Сервис заказов
```yaml
openapi: 3.1.0
info:
  title: Order Service
  version: 1.0.0
paths:
  /orders/id/{order_id}:
    get:
      tags:
      - Orders
      summary: Get order by ID
      operationId: order_get_by_id_orders_id__order_id__get
      parameters:
      - name: order_id
        in: path
        required: true
        schema:
          type: string
          format: uuid
          title: Order Id
      responses:
        '200':
          description: Successful Response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/OrderReturn'
        '422':
          description: Validation Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HTTPValidationError'
  /orders/user/{req_uname}:
    get:
      tags:
      - Orders
      summary: Get orders for User
      operationId: orders_get_for_uname_orders_user__req_uname__get
      parameters:
      - name: req_uname
        in: path
        required: true
        schema:
          type: string
          title: Req Uname
      responses:
        '200':
          description: Successful Response
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/OrderReturn'
                title: Response Orders Get For Uname Orders User  Req Uname  Get
        '422':
          description: Validation Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HTTPValidationError'
components:
  schemas:
    OrderReturn:
      properties:
        price:
          type: string
          pattern: ^(?!^[-+.]*$)[+-]?0*(?:\d{0,13}|(?=[\d.]{1,16}0*$)\d{0,13}\.\d{0,2}0*$)
          title: Price
        username:
          type: string
          maxLength: 100
          minLength: 1
          title: Username
        id:
          type: string
          format: uuid
          title: Id
        status:
          type: string
          title: Status
        placed_at:
          type: string
          format: date-time
          title: Placed At
        updated_at:
          type: string
          format: date-time
          title: Updated At
      type: object
      required:
      - price
      - username
      - id
      - status
      - placed_at
      - updated_at
      title: OrderReturn
    ValidationError:
      properties:
        loc:
          items:
            anyOf:
            - type: string
            - type: integer
          type: array
          title: Location
        msg:
          type: string
          title: Message
        type:
          type: string
          title: Error Type
      type: object
      required:
      - loc
      - msg
      - type
      title: ValidationError
```

### Сервис биллинга:
```yaml
openapi: 3.1.0
info:
  title: Billing Service
  version: 1.0.0
paths:
  /register:
    post:
      tags:
      - Wallet
      summary: Create Wallet for User
      operationId: wallet_create_new_register_post
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/WalletCreate'
        required: true
      responses:
        '201':
          description: Successful Response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/WalletReturn'
        '422':
          description: Validation Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HTTPValidationError'
  /transaction:
    post:
      tags:
      - Wallet
      - Transactions
      summary: Create new transaction
      operationId: transaction_create_transaction_post
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/TransactionCreate'
        required: true
      responses:
        '201':
          description: Successful Response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionReturn'
        '422':
          description: Validation Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HTTPValidationError'
  /wallet/{req_uname}:
    get:
      tags:
      - Wallet
      summary: Get current balance
      operationId: get_wallet_balance_wallet__req_uname__get
      parameters:
      - name: req_uname
        in: path
        required: true
        schema:
          type: string
          title: Req Uname
      responses:
        '200':
          description: Successful Response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/WalletReturn'
        '422':
          description: Validation Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HTTPValidationError'
components:
  schemas:
    HTTPValidationError:
      properties:
        detail:
          items:
            $ref: '#/components/schemas/ValidationError'
          type: array
          title: Detail
      type: object
      title: HTTPValidationError
    TransactionCreate:
      properties:
        amount:
          anyOf:
          - type: number
          - type: string
            pattern: ^(?!^[-+.]*$)[+-]?0*(?:\d{0,13}|(?=[\d.]{1,16}0*$)\d{0,13}\.\d{0,2}0*$)
          title: Amount
        username:
          type: string
          maxLength: 100
          minLength: 1
          title: Username
      type: object
      required:
      - amount
      - username
      title: TransactionCreate
    TransactionReturn:
      properties:
        amount:
          type: string
          pattern: ^(?!^[-+.]*$)[+-]?0*(?:\d{0,13}|(?=[\d.]{1,16}0*$)\d{0,13}\.\d{0,2}0*$)
          title: Amount
        username:
          type: string
          maxLength: 100
          minLength: 1
          title: Username
        id:
          type: string
          format: uuid
          title: Id
      type: object
      required:
      - amount
      - username
      - id
      title: TransactionReturn
    ValidationError:
      properties:
        loc:
          items:
            anyOf:
            - type: string
            - type: integer
          type: array
          title: Location
        msg:
          type: string
          title: Message
        type:
          type: string
          title: Error Type
      type: object
      required:
      - loc
      - msg
      - type
      title: ValidationError
    WalletCreate:
      properties:
        username:
          type: string
          maxLength: 100
          minLength: 1
          title: Username
      type: object
      required:
      - username
      title: WalletCreate
    WalletReturn:
      properties:
        amount:
          type: string
          pattern: ^(?!^[-+.]*$)[+-]?0*(?:\d{0,13}|(?=[\d.]{1,16}0*$)\d{0,13}\.\d{0,2}0*$)
          title: Amount
        username:
          type: string
          maxLength: 100
          minLength: 1
          title: Username
      type: object
      required:
      - amount
      - username
      title: WalletReturn
```

### Сервис профилей
```yaml
openapi: 3.1.0
info:
  title: Profile Service
  version: 1.0.0
paths:
  /users:
    post:
      summary: Create User
      operationId: create_user_users_post
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UserCreate'
      responses:
        '201':
          description: Successful Response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '422':
          description: Validation Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HTTPValidationError'
    get:
      summary: List Users
      operationId: list_users_users_get
      parameters:
      - name: skip
        in: query
        required: false
        schema:
          type: integer
          default: 0
          title: Skip
      - name: limit
        in: query
        required: false
        schema:
          type: integer
          default: 10
          title: Limit
      responses:
        '200':
          description: Successful Response
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/User'
                title: Response List Users Users Get
        '422':
          description: Validation Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HTTPValidationError'
  /users/{username}:
    get:
      summary: Read User
      operationId: read_user_users__username__get
      parameters:
      - name: username
        in: path
        required: true
        schema:
          type: string
          title: Username
      responses:
        '200':
          description: Successful Response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '422':
          description: Validation Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HTTPValidationError'
    put:
      summary: Update User
      operationId: update_user_users__username__put
      parameters:
      - name: username
        in: path
        required: true
        schema:
          type: string
          title: Username
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UserUpdate'
      responses:
        '200':
          description: Successful Response
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '422':
          description: Validation Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HTTPValidationError'
    delete:
      summary: Delete User
      operationId: delete_user_users__username__delete
      parameters:
      - name: username
        in: path
        required: true
        schema:
          type: string
          title: Username
      responses:
        '204':
          description: Successful Response
        '422':
          description: Validation Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HTTPValidationError'
  /cause-5xx:
    get:
      summary: Cause 5Xx
      operationId: cause_5xx_cause_5xx_get
      responses:
        '200':
          description: Successful Response
          content:
            application/json:
              schema: {}
components:
  schemas:
    HTTPValidationError:
      properties:
        detail:
          items:
            $ref: '#/components/schemas/ValidationError'
          type: array
          title: Detail
      type: object
      title: HTTPValidationError
    User:
      properties:
        firstName:
          type: string
          maxLength: 100
          minLength: 1
          title: Firstname
        lastName:
          type: string
          maxLength: 100
          minLength: 1
          title: Lastname
        email:
          type: string
          format: email
          title: Email
        phone:
          type: string
          maxLength: 12
          minLength: 12
          title: Phone
        username:
          type: string
          maxLength: 100
          minLength: 1
          title: Username
      type: object
      required:
      - firstName
      - lastName
      - email
      - phone
      - username
      title: User
    UserCreate:
      properties:
        firstName:
          type: string
          maxLength: 100
          minLength: 1
          title: Firstname
        lastName:
          type: string
          maxLength: 100
          minLength: 1
          title: Lastname
        email:
          type: string
          format: email
          title: Email
        phone:
          type: string
          maxLength: 12
          minLength: 12
          title: Phone
        username:
          type: string
          maxLength: 100
          minLength: 1
          title: Username
      type: object
      required:
      - firstName
      - lastName
      - email
      - phone
      - username
      title: UserCreate
    UserUpdate:
      properties:
        firstName:
          type: string
          maxLength: 100
          minLength: 1
          title: Firstname
        lastName:
          type: string
          maxLength: 100
          minLength: 1
          title: Lastname
        email:
          type: string
          format: email
          title: Email
        phone:
          type: string
          maxLength: 12
          minLength: 12
          title: Phone
      type: object
      required:
      - firstName
      - lastName
      - email
      - phone
      title: UserUpdate
    ValidationError:
      properties:
        loc:
          items:
            anyOf:
            - type: string
            - type: integer
          type: array
          title: Location
        msg:
          type: string
          title: Message
        type:
          type: string
          title: Error Type
      type: object
      required:
      - loc
      - msg
      - type
      title: ValidationError
```

### Сервис нотификаций
```yaml
openapi: 3.1.0
info:
  title: Notification Service
  version: 1.0.0
paths:
  /user/{req_uname}:
    get:
      tags:
      - Notifications
      summary: Get notifications for user
      operationId: get_notifications_for_user_user__req_uname__get
      parameters:
      - name: req_uname
        in: path
        required: true
        schema:
          type: string
          title: Req Uname
      responses:
        '200':
          description: Successful Response
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/NotificationReturn'
                title: Response Get Notifications For User User  Req Uname  Get
        '422':
          description: Validation Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HTTPValidationError'
  /order/{order_id}:
    get:
      tags:
      - Notifications
      summary: Get notifications for order
      operationId: get_notifications_for_order_order__order_id__get
      parameters:
      - name: order_id
        in: path
        required: true
        schema:
          type: string
          format: uuid
          title: Order Id
      responses:
        '200':
          description: Successful Response
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/NotificationReturn'
                title: Response Get Notifications For Order Order  Order Id  Get
        '422':
          description: Validation Error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HTTPValidationError'
components:
  schemas:
    HTTPValidationError:
      properties:
        detail:
          items:
            $ref: '#/components/schemas/ValidationError'
          type: array
          title: Detail
      type: object
      title: HTTPValidationError
    NotificationReturn:
      properties:
        order_id:
          type: string
          format: uuid
          title: Order Id
        username:
          type: string
          maxLength: 100
          minLength: 1
          title: Username
        id:
          type: string
          format: uuid
          title: Id
        email:
          type: string
          format: email
          title: Email
        sent_at:
          type: string
          format: date-time
          title: Sent At
        text:
          type: string
          title: Text
      type: object
      required:
      - order_id
      - username
      - id
      - email
      - sent_at
      - text
      title: NotificationReturn
    ValidationError:
      properties:
        loc:
          items:
            anyOf:
            - type: string
            - type: integer
          type: array
          title: Location
        msg:
          type: string
          title: Message
        type:
          type: string
          title: Error Type
      type: object
      required:
      - loc
      - msg
      - type
      title: ValidationError
```

## Kafka
### Топик orders.create
Собщение о запросе на создание заказа
- **Producer**: API Gateway
- **Consumer**: Orders Service
- **Message structure**: OrderCreateRequested
```json
{
  "username": "string",
  "price": "decimal"
}
```

### Топик orders.pending
Собщение о запросе на создание заказа
- **Producer**: Orders Service
- **Consumer**: Billing Service
- **Message structure**: OrderPending
```json
{
  "order_id": "uuid",
  "username": "string",
  "amount": "decimal"
}
```

### Топик billing.payments
Собщение об обработанных запросах на оплату
- **Producer**: Billing Service
- **Consumer**: Orders Service
- **Message structure**: PaymentProcessed
```json
{
  "order_id": "uuid",
  "paid": "boolean",
  "payment_id": "uuid",
}
```

### Топик ordersnotifications.orders
Собщение о необходимости отправки уведомления
- **Producer**: Orders Service
- **Consumer**: Notification Service
- **Message structure**: OrderUpdateMessage
```json
{
  "order_id": "uuid",
  "username": "string",
  "event": "string",
  "updated_at": "datetime"
}
```