//
//  SidePanelPreview.swift
//  QuickShelf
//
//  Created by slowhand on 2025/08/26.
//

import AppKit
import QuickLookUI
import Carbon.HIToolbox

final class SlidePanelPreview: NSObject {
    static let shared = SlidePanelPreview()

    private var panel: NSPanel?
    private var previewView: QLPreviewView?
    private weak var anchorWindow: NSWindow?
    private var closeEvent: Any?

    func show(url: URL, beside anchor: NSWindow, size: NSSize = NSSize(width: 360, height: 300)) {
        anchorWindow = anchor
        let panel = self.panel == nil ? makePanel(size: size) : self.panel!
        if self.panel == nil { self.panel = panel }

        ensurePreviewViewAlive()
        previewView?.previewItem = url as NSURL
        positionPanelBesideAnchor(panel: panel, anchor: anchor, size: size)

        // nonactivating
        panel.orderFrontRegardless()

        // Close with the ESC key
        if closeEvent == nil {
            closeEvent = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
                if Int(event.keyCode) == kVK_Escape {
                    self?.panel?.orderOut(nil)
                    return nil
                }
                return event
            }
        }
    }

    func hide() {
        panel?.orderOut(nil)
    }

    private func makePanel(size: NSSize) -> NSPanel {
        let panel = NSPanel(
            contentRect: NSRect(origin: .zero, size: size),
            styleMask: [.nonactivatingPanel, .titled, .closable, .hudWindow],
            backing: .buffered,
            defer: false
        )
        panel.isFloatingPanel = true
        panel.hidesOnDeactivate = false
        panel.hasShadow = true
        panel.level = .floating
        panel.collectionBehavior = [.moveToActiveSpace, .transient]
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.becomesKeyOnlyIfNeeded = true
        return panel
    }

    private func ensurePreviewViewAlive() {
        if previewView == nil || (previewView?.window == nil && panel?.contentView == nil) {
            let ql = QLPreviewView(frame: .zero, style: .normal)
            ql?.autostarts = true
            ql?.shouldCloseWithWindow = false
            panel?.contentView = ql
            previewView = ql
        }
    }

    private func positionPanelBesideAnchor(panel: NSPanel, anchor: NSWindow, size: NSSize) {
        let anchorFrame = anchor.frame
        let origin = NSPoint(x: anchorFrame.maxX + 8,
                             y: anchorFrame.minY)
        panel.setFrame(NSRect(origin: origin, size: size), display: true)
    }
}

