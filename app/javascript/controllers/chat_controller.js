import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static values = { roomId: Number, currentUserId: Number }
  static targets = [ "messages", "input" ]

  connect() {
    this.channel = consumer.subscriptions.create(
      { channel: "ConversationChannel", room_id: this.roomIdValue },
      {
        received: (data) => {
          this.appendMessage(data)
        }
      }
    )
  }

  disconnect() {
    this.channel.unsubscribe()
  }

  appendMessage(data) {
    const isCurrentUser = (data.sender_id === this.currentUserIdValue)

    const alignmentClass = isCurrentUser ? 'justify-end' : 'justify-start'
    const bubbleClass = isCurrentUser ? 'bg-[#dcf8c6] text-gray-800 rounded-tr-none' : 'bg-white text-gray-800 rounded-tl-none'
    
    const nameHtml = !isCurrentUser ? `<p class="font-bold text-xs text-blue-500 mb-1">${data.user_name}</p>` : ''

    const html = `
      <div class="mb-4 flex ${alignmentClass}">
        <div class="relative px-4 py-2 text-sm shadow rounded-lg max-w-md ${bubbleClass}">
          ${nameHtml}
          <p>${data.message}</p>
          <p class="text-[10px] text-gray-500 text-right mt-1">${data.created_at}</p>
        </div>
      </div>
    `
    
    this.messagesTarget.insertAdjacentHTML("beforeend", html)
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }

  clearInput() {
    this.inputTarget.value = ""
  }
}