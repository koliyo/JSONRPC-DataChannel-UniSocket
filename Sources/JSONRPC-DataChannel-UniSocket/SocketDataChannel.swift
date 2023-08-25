import JSONRPC
import UniSocket
import Foundation

extension DataChannel {
  // let socket: UniSocket

  public init(socket: UniSocket) {
    let writeHandler = { @Sendable data in
      try socket.send(data)
    }

    // let dataSequence = DataSequence { continuation in
    //     // continuation.yield(with: Result {
    //     //   try socket.recv()
    //     // })

    //     do {
    //       let d = try socket.recv()
    //       continuation.yield(d)
    //       continuation.onTermination = { @Sendable _ in
    //         print("Terminated")
    //       }
    //     } catch {
    //     }
    // }

    let dataSequence = DataSequence {

        do {
          let d = try socket.recv()
          return d
        } catch {
          print("DataChannel socket error: \(error)")
          return nil
        }

    } onCancel: { @Sendable () in print("Canceled.") }


    self.init(writeHandler: writeHandler, dataSequence: dataSequence)
  }

}
