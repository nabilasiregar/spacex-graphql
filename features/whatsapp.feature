Feature: WhatsApp Desktop

  Scenario Outline: Verify user can download whatsapp via appstore/web
    When user download whatsapp via "<case>"
    Then whatsapp should be downloaded successfully
    Examples:
        | test_id | case    |
        | 01      | appstore|
        | 02      | web     |

  Scenario: 03-Test QR code to use whatsapp on desktop
    Given user has launched whatsapp desktop
    When user see a setup guide
    And user validate setup guide instructions
    Then user should be able to sign in via QR code 

  Scenario: 04-User able to create, read, and delete a chat
    When user click on create new chat icon
    And user search "contact_name" in search bar
    Then user should see correct contact name
    When user click on the contact
    And user is on the chatroom page
    Then user should be able to type a message
    And send the message successfully

    Given user is on homepage
    When user search "contact_name" in search bar
    Then user should be able to see their conversation
    And user able to scroll their conversation

    When user click on action dropdown icon
    And user click on "Delete chat" button
    Then user should see a confirmation modal
    When user "confirm" chat deletion
    Then chat should be deleted successfully

  Scenario: 05-Verify chats on desktop are synced with the one in phone
    Given user has launched whatsapp desktop
    When user is signed in
    Then user should see the name of all synced contacts on the chat window

  Scenario: 06-User should be able to see their profile
    Given user is on profile page
    Then user able to see their profile picture
    And user validate their profile

  Scenario: 07-User able to receive a notification and see the time message was sent
    When user received a notification
    Then user should be able to see the unread message
    When user read the message
    Then user able to see the time the message was sent

  Scenario: 08-Verify chat window displays the last updated chatting time
    When user is on homepage
    Then user should see chat list shown in most recent order

  Scenario Outline: User can see all delivered and received messages
    When user successfully "delivered" a message with status "<status>"
    Then user should see "<checklist_type>" checklist
    Examples:
        | test_id | checklist_type | status       |
        | 09      | single         | not received |
        | 10      | double         | received     |
